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
final class AudioManager {
    static let sharedInstance = AudioManager()

    private var avPlayer: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var canellable: AnyCancellable?

    /// Default Queue
    private var nowPlayableTrackQueue: [Track] = []

    private init() {}

    deinit {
        canellable?.cancel()
    }

    private func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}

        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}

        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
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

    func updateNowPlayingInfo() {
        guard let avPlayer = avPlayer, let currentItem = avPlayer.currentItem else { return }

        let artworkImage = UIImage(named: "modm_highres")!

        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: "thisis Title",
            MPMediaItemPropertyArtist: "ArtistName",
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: CGSize(width: 300, height: 300)) { _ in artworkImage },
            MPMediaItemPropertyAlbumTitle: "Album Title",
            MPMediaItemPropertyPlaybackDuration: currentItem.duration.seconds,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: avPlayer.currentTime().seconds,
            MPNowPlayingInfoPropertyPlaybackRate: avPlayer.rate
        ]

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func startAudio() {
        activateSession()

        // TODO: change the url to whatever audio you want to play

        // let url = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3")
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
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }

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
}
