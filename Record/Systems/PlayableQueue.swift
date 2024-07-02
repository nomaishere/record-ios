//
//  PlayableQueue.swift
//  Record
//
//  Created by nomamac2 on 6/28/24.
//

import AVFoundation
import Foundation

/// Note: PlayableQueue doesn't know music is playing now.
class PlayableQueue {
    static let sharedInstance = PlayableQueue()

    /// First item of array is the track which playing now.
    ///
    /// This array must be updated by out-of-app event like nowplayable command
    private var queueOfTracks: [Track]
    private var avPlayerItems: [AVPlayerItem]
    private var nowPlayableStaticMetadatas: [NowPlayableStaticMetadata]

    // TODO:
    private var doesAppHasUnfinishedQueue: Bool = false

    private init() {
        // Check if application has unfinished queue
        if doesAppHasUnfinishedQueue {
            queueOfTracks = [] // TODO:
            avPlayerItems = []
            nowPlayableStaticMetadatas = []
        } else {
            queueOfTracks = []
            avPlayerItems = []
            nowPlayableStaticMetadatas = []
        }
    }

    // MARK: - Queue Control Method

    // This methods shouldn't be called directly in view. View can control audio by AudioManager.
    func deleteAllTracksInQueue() {
        queueOfTracks.removeAll()
    }

    func addTracksAtEndofQueue(tracks: [Track]) {
        queueOfTracks.append(contentsOf: tracks)
        /*
        for track in tracks {
            avPlayerItems.append(AVPlayerItem(url: track.audioLocalURL))
            // TODO: append nowPlayableStaticMetadatas here
        }
         */
    }
}
