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
final class AudioManager {
    static let sharedInstance = AudioManager()

    private var avPlayer: AVPlayer?
    private var avQueuePlayer: AVQueuePlayer
    private var avAudioSession = AVAudioSession.sharedInstance()
    private var canellable: AnyCancellable?

    let playableQueue: PlayableQueue

    enum PlayerState {
        case stopped
        case playing
        case paused
    }

    private var playerState: PlayerState = .stopped {
        didSet {
            NSLog("%@", "**** Set player state \(playerState)")
        }
    }

    let nowPlayableBehavior: NowPlayable = IOSNowPlayableBehavior()

    private var avPlayerItemObserver: NSKeyValueObservation!

    // MARK: - Initializer

    private init() {
        NSLog("Initialize AudioManager")
        self.playableQueue = PlayableQueue.sharedInstance
        self.avQueuePlayer = AVQueuePlayer()
        avQueuePlayer.allowsExternalPlayback = true

        setupRemoteControls()
    }

    deinit {
        canellable?.cancel()
    }

    private func activateSession() throws {
        try avAudioSession.setCategory(.playback, mode: .default)

        try avAudioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }

    func prepareMetadata() -> [AVMetadataItem] {
        var metadatas: [AVMetadataItem] = []

        let title = AVMutableMetadataItem()
        title.identifier = .commonIdentifierTitle
        title.value = "Somozu Combat" as NSString
        title.extendedLanguageTag = "und" // undetermined
        metadatas.append(title)

        let artist = AVMutableMetadataItem()
        artist.identifier = .commonIdentifierArtist
        artist.value = "Khundi Panda" as NSString
        artist.extendedLanguageTag = "und"
        metadatas.append(artist)

        /*
         let artwork = AVMutableMetadataItem()
         if let image = UIImage(named: "modm_highres") {
             if let imageData = image.jpegData(compressionQuality: 1.0) {
                 artwork.identifier = .commonIdentifierArtwork
                 artwork.value = imageData as NSData
                 artwork.dataType = kCMMetadataBaseDataType_JPEG as String
                 artwork.extendedLanguageTag = "und"
             }
         }
         metadatas.append(artwork)
          */

        // let artwork = AVMutableMetadataItem()
        return metadatas
    }

    func updateNowPlayingStaticMetadata(_ metadata: NowPlayableStaticMetadata) {
        var nowPlayingInfo = [String: Any]()

        // nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300)) { _ in artworkImage },

        NSLog("Set Track Metadata: title \(metadata.title)")
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

    // NOTE: Depreacted Method
    func startAudio() {
        do {
            try activateSession()
        } catch {}

        // TODO: change the url to whatever audio you want to play

        let path = Bundle.main.path(forResource: "01 Modm Intro.aif", ofType: nil)!
        let url = URL(filePath: path)

        let playerItem = AVPlayerItem(url: url)
        // let playerAsset = AVAsset(url: url)

        // var test = AVPlayerItem(url: url)

        if let avPlayer = avPlayer {
            avPlayer.replaceCurrentItem(with: playerItem)
        } else {
            avPlayer = AVPlayer(playerItem: playerItem)
        }

        canellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                guard let me = self else { return }

                me.deactivateSession()
            }

        if let player = avPlayer {
            player.play()
        }
    }

    func deactivateSession() {
        do {
            try avAudioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }

    // MARK: - Method for view

    func play() {
        if let player = avPlayer {
            player.play()
        }
    }

    func pause() {
        if let player = avPlayer {
            player.pause()
        }
    }

    func getPlaybackDuration() -> Double {
        guard let player = avPlayer else {
            return 0
        }

        return player.currentItem?.duration.seconds ?? 0
    }

    /// Delete all tracks in queue (include now-playing track) and start playing tracks.
    ///
    /// Usually called when user click a "playing album" button.
    func playTracksAfterCleanQueue(tracks: [Track]) {
        switch playerState {
        case .stopped:
            NSLog("start playing \(tracks.count) tracks")
            playableQueue.addTracksAtEndofQueue(tracks: tracks)

            for track in tracks {
                avQueuePlayer.insert(AVPlayerItem(url: track.audioLocalURL), after: nil)
            }

            do {
                try activateSession()
            } catch {}
            avPlayerItemObserver = avQueuePlayer.observe(\.currentItem, options: .initial) {
                [unowned self] _, _ in
                self.handleAvPlayerItemChange()
            }
            playerState = .playing
            avQueuePlayer.play()

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
            NSLog("AVQueuePlayer End Playing!")
            avPlayerItemObserver = nil
            playerState = .stopped
            // TODO: Deactivate seesion
            return
        }

        NSLog("Next Track Started!")

        // TODO: Update NowPlayingInfo here using MPNowPlayingInfoCenter.default()
        // let metadata =
        // updateNowPlayingStaticMetadata(metadata: metadata)
    }
}

private func setupRemoteControls() {
    let commands = MPRemoteCommandCenter.shared()

    commands.playCommand.addTarget { _ in
        AudioManager.sharedInstance.pause()
        return .success
    }

    commands.playCommand.addTarget { _ in
        AudioManager.sharedInstance.play()
        return .success
    }
}
