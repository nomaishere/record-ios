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
    // static let sharedInstance = AudioManager()

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

    // MARK: - Initializer

    init() {
        NSLog("Initialize AudioManager")
        self.nowPlayingTrack = nil
        self.playableQueue = PlayableQueue.sharedInstance
        self.avQueuePlayer = AVQueuePlayer(items: [])
        avQueuePlayer.allowsExternalPlayback = true

        let MPRemoteCommandCenter = MPRemoteCommandCenter.shared()

        /*
         MPRemoteCommandCenter.playCommand.addTarget { [unowned self] _ in
             if self.avQueuePlayer.rate == 0.0 {
                 self.play()
                 return .success
             }
             return .commandFailed
         }*/

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

        self.avPlayerItemObserver = avQueuePlayer.observe(\.currentItem, options: .initial) {
            [unowned self] _, _ in
            self.handleAvPlayerItemChange()
        }
    }

    deinit {}

    private func activateSession() throws {
        // TODO: Add NotificationCenter.default.addObserver(forName: AVAudioSession.interruptionNotification, object: audioSession, queue: .main)

        try avAudioSession.setCategory(.playback, mode: .default)

        try avAudioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }

    func updateNowPlayingStaticMetadata(_ metadata: NowPlayableStaticMetadata) {
        var nowPlayingInfo = [String: Any]()

        NSLog("Update to \(metadata.title)")
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

    // MARK: - Method for view

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

    /// Delete all tracks in queue (include now-playing track) and start playing tracks.
    ///
    /// Usually called when user click a "playing album" button.
    func playTracksAfterCleanQueue(tracks: [Track]) {
        switch playerState {
        case .stopped:
            playableQueue.addTracksAtEndofQueue(tracks: tracks)

            for (index, track) in tracks.enumerated() {
                avQueuePlayer.insert(playableQueue.avPlayerItems[index], after: nil)
            }

            do {
                try activateSession()
            } catch {}

            do {
                // try nowPlayableBehavior.handleNowPlayableConfiguration(commands: registeredCommands, disabledCommands: enabledCommands, commandHandler: handleCommand(command:event:), interruptionHandler: handleInterrupt(with:))
            } catch {}

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
        // play()
    }

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
