//
//  PlayableQueue.swift
//  Record
//
//  Created by nomamac2 on 6/28/24.
//

import Foundation

/// PlayableQueue is
class PlayableQueue {
    static let sharedInstance = PlayableQueue()

    private var queueOfTracks: [Track]

    // TODO:
    private var doesAppHasUnfinishedQueue: Bool = false

    private init() {
        if doesAppHasUnfinishedQueue {
            queueOfTracks = [] // TODO:
        } else {
            queueOfTracks = []
        }
    }
}
