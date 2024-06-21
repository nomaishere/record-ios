//
//  AudioManager.swift
//  Record
//
//  Created by nomamac2 on 6/20/24.
//

import AVFoundation
import Combine
import Foundation

/// AudioManager is highest-level controller that manager all feature about audio.
final class AudioManager {
    static let sharedInstance = AudioManager()

    private var player: AVPlayer?

    private var session = AVAudioSession.sharedInstance()

    private var canellable: AnyCancellable?

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

    func startAudio() {
        // activate our session before playing audio
        activateSession()

        // TODO: change the url to whatever audio you want to play
        let url = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3")
        let playerItem = AVPlayerItem(url: url!)
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }

        // Listen audio end
        canellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                guard let me = self else { return }

                me.deactivateSession()
            }

        if let player = player {
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
        if let player = player {
            player.play()
        }
    }

    func pause() {
        if let player = player {
            player.pause()
        }
    }

    func getPlaybackDuration() -> Double {
        guard let player = player else {
            return 0
        }

        return player.currentItem?.duration.seconds ?? 0
    }
}
