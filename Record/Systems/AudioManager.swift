//
//  AudioManager.swift
//  Record
//
//  Created by nomamac2 on 6/20/24.
//

import AVFoundation
import AVKit
import Combine
import Foundation
import MediaPlayer

/// AudioManager is highest-level controller that manager all feature about audio.
///
final class AudioManager: ObservableObject {
    private var avQueuePlayer: AVQueuePlayer
    private var avAudioSession = AVAudioSession.sharedInstance()

    let playableQueue: PlayableQueue

    enum PlayerState {
        case stopped
        case playing
        case paused
    }

    @Published var playerState: PlayerState = .stopped {
        didSet {
            // NSLog("%@", "**** Set player state \(playerState)")
        }
    }

    @Published var nowPlayingTrack: Track?

    let nowPlayableBehavior: NowPlayable = IOSNowPlayableBehavior()

    // `true` if the current session has been interrupted by another app.
    private var isInterrupted: Bool = false

    private var avPlayerItemObserver: NSKeyValueObservation!
    private var rateObserver: NSKeyValueObservation!
    private var statusObserver: NSObjectProtocol!

    // MARK: - Initializer

    init() {
        NSLog("Initialize AudioManager")
        self.nowPlayingTrack = nil
        self.playableQueue = PlayableQueue.sharedInstance
        self.avQueuePlayer = AVQueuePlayer(items: [])
        avQueuePlayer.allowsExternalPlayback = true

        addHandlerAtMPRemoteCommandCenter()
        addObserverAtAvQueuePlayer()
    }

    deinit {}

    func addHandlerAtMPRemoteCommandCenter() {
        let MPRemoteCommandCenter = MPRemoteCommandCenter.shared()
        MPRemoteCommandCenter.togglePlayPauseCommand.addTarget { [unowned self] _ in
            self.togglePlayPause()
            return .success
        }

        MPRemoteCommandCenter.nextTrackCommand.addTarget { [unowned self] _ in
            self.nextTrack()
            return .success
        }

        MPRemoteCommandCenter.previousTrackCommand.addTarget { [unowned self] _ in
            self.previousTrack()
            return .success
        }

        /*
         MPRemoteCommandCenter.changePlaybackPositionCommand.addTarget { [unowned self] _ in
             self.changePlaybackPosition()
             return .success
         }*/

        MPRemoteCommandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in

            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }

            self.changePlaybackPosition(to: event.positionTime)
            return .success
        }
    }

    func addObserverAtAvQueuePlayer() {
        avPlayerItemObserver = avQueuePlayer.observe(\.currentItem, options: .initial) {
            [unowned self] _, _ in
            self.handleAvPlayerItemChange()
        }

        rateObserver = avQueuePlayer.observe(\.rate, options: .initial) {
            [unowned self] _, _ in
            self.handlePlaybackChange()
        }

        statusObserver = avQueuePlayer.observe(\.currentItem?.status, options: .initial) {
            [unowned self] _, _ in
            self.handlePlaybackChange()
        }
    }

    private func activateSession() throws {
        // TODO: Add NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: .main)

        try avAudioSession.setCategory(.playback, mode: .default)

        try avAudioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }

    // MARK: - Method For Updating MPNowPlayingInfoCenter

    func updateNowPlayingStaticMetadata(_ metadata: NowPlayableStaticMetadata) {
        var nowPlayingInfo = [String: Any]()

        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = metadata.mediaType.rawValue
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func updateNowPlayingPlaybackInfo(_ metadata: NowPlayableDynamicMetadata) {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()

        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Playback Control

    func play() {
        avQueuePlayer.play()
        playerState = .playing
    }

    func pause() {
        avQueuePlayer.pause()
        playerState = .paused
    }

    func stop() {
        avQueuePlayer.pause()
        playerState = .stopped
    }

    func togglePlayPause() {
        switch playerState {
        case .stopped:
            play()
        case .playing:
            pause()
        case .paused:
            play()
        }
    }

    func nextTrack() {
        if playableQueue.doesNextTrackExist() {
            playableQueue.handleNowPlayingItemMoveNext()
            avQueuePlayer.advanceToNextItem()
        }
    }

    func previousTrack() {
        if playableQueue.doesPreviousTrackExist() {
            let currentItems = avQueuePlayer.items() // 5, 3번째 트랙 재생중
            let currentItem = avQueuePlayer.currentItem!
            let previousItem = playableQueue.getPreviousAVPlayerItem()!
            playableQueue.handleNowPlayingItemMovePrevious()

            avQueuePlayer.insert(previousItem, after: currentItem)
            avQueuePlayer.advanceToNextItem()
            avQueuePlayer.insert(currentItem, after: avQueuePlayer.currentItem)

            /*
             avQueuePlayer.insert(previousItem, after: nil)
             for item in currentItems {
                 avQueuePlayer.insert(item, after: nil)
             }
              */
            NSLog("\(avQueuePlayer.items().count) items in avQueuePlayer in previousTrack()")

            play()
        }
    }

    func changePlaybackPosition(to position: TimeInterval) {
        guard playerState != .stopped else { return }

        avQueuePlayer.seek(to: CMTime(seconds: position, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero) {
            isFinished in
            if isFinished {
                self.handlePlaybackChange()
            }
        }
    }

    // MARK: - Useful Method

    /// Delete all tracks in queue (include now-playing track) and start playing tracks.
    ///
    /// Usually called when user click a "playing album" button.
    func playTracksAfterCleanQueue(tracks: [Track]) {
        switch playerState {
        case .stopped:
            playableQueue.addTracksAtEndofQueue(tracks: tracks)

            for (index, _) in tracks.enumerated() {
                avQueuePlayer.insert(playableQueue.avPlayerItems[index], after: nil)
            }

            do {
                try activateSession()
            } catch {}

            // TODO: Attach Interrupt Handler

            play()
            handleAvPlayerItemChange()

        case .playing:
            pause()
            playableQueue.deleteAllTracksInQueue()
            playableQueue.addTracksAtEndofQueue(tracks: tracks)

        case .paused:
            playableQueue.deleteAllTracksInQueue()
            playableQueue.addTracksAtEndofQueue(tracks: tracks)
        }
    }

    // MARK: - Handler for Observer

    private func handleAvPlayerItemChange() {
        guard playerState != .stopped else { return }

        guard let currentItem = avQueuePlayer.currentItem else {
            NSLog("\(avQueuePlayer.items().count) items in avQueuePlayer")
            avPlayerItemObserver = nil
            playerState = .stopped
            // TODO: Deactivate seesion

            return
        }

        guard let currentIndex = playableQueue.avPlayerItems.firstIndex(where: { $0 == currentItem }) else {
            NSLog("[AudioManager] : No matching AVPlayerItem in queue")
            return
        }

        if currentIndex == playableQueue.nowPlayingIndex {
        } else if currentIndex == playableQueue.nowPlayingIndex + 1 {
        } else if currentIndex == playableQueue.nowPlayingIndex - 1 {
        } else {
            NSLog("[AudioManager] : AVQueuePlayer currentItem doesn't point previous, now, or next.")
        }

        // Update nowPlayingTrack (Published Variable)
        nowPlayingTrack = playableQueue.getNowPlayingTrack()

        // Update NowPlayable Metadata
        guard let currentNowPlayableStaticMetadata = playableQueue.getCurrentNowPlayableStaticMetadata() else { return }
        updateNowPlayingStaticMetadata(currentNowPlayableStaticMetadata)
    }

    private func handlePlaybackChange() {
        guard playerState != .stopped else { return }

        guard let currentItem = avQueuePlayer.currentItem else { return }

        guard currentItem.status == .readyToPlay else { return }

        let dynamicMetadata = NowPlayableDynamicMetadata(rate: avQueuePlayer.rate,
                                                         position: Float(currentItem.currentTime().seconds),
                                                         duration: Float(currentItem.duration.seconds))

        updateNowPlayingPlaybackInfo(dynamicMetadata)
    }

    // TODO: Attach Interrupt Handler
    private func handleInterrupt(with interruption: NowPlayableInterruption) {
        switch interruption {
        case .began:
            isInterrupted = true
        case .ended(let shouldPlay):
            isInterrupted = false

            switch playerState {
            case .stopped:
                break

            case .playing where shouldPlay:
                avQueuePlayer.play()

            case .playing:
                playerState = .paused

            case .paused:
                break
            }
        case .failed(let error):
            print(error.localizedDescription)
            // optOut here
            // avPlayerItemObserver = nil
        }
    }
}
