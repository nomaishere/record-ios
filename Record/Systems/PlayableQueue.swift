//
//  PlayableQueue.swift
//  Record
//
//  Created by nomamac2 on 6/28/24.
//

import AVFoundation
import Foundation
import MediaPlayer

/// PlayableQueue's three arrays contain datas for playing queue.
///
/// Note: PlayableQueue's array doesn't match to player UI 'In Queue' Tab.
class PlayableQueue {
    static let sharedInstance = PlayableQueue()

    /// Array of tracks
    ///
    /// First item of array is not the track which playing now.
    ///
    /// This array must be updated by out-of-app event like nowplayable command
    private var queueOfTracks: [Track]
    public private(set) var avPlayerItems: [AVPlayerItem]
    /// player can find a proper nowPlayableStaticMetadata by using avQueuePlayer.currentItem(return AVPlayerItem)
    private var nowPlayableStaticMetadatas: [NowPlayableStaticMetadata]

    /// Index of now playing track.
    public private(set) var nowPlayingIndex: Int
    public private(set) var lenghtOfQueue: Int

    // TODO:
    private var doesAppHasUnfinishedQueue: Bool = false

    private init() {
        // Check if application has unfinished queue
        if doesAppHasUnfinishedQueue {
            // TODO:
            queueOfTracks = []
            avPlayerItems = []
            nowPlayableStaticMetadatas = []
            nowPlayingIndex = 0
            lenghtOfQueue = 0

        } else {
            queueOfTracks = []
            avPlayerItems = []
            nowPlayableStaticMetadatas = []
            nowPlayingIndex = 0
            lenghtOfQueue = 0
        }
    }

    // MARK: - Getter

    func getPreviousAVPlayerItem() -> AVPlayerItem? {
        if doesPreviousTrackExist() {
            return avPlayerItems[nowPlayingIndex - 1]
        } else { return nil }
    }

    func getNowPlayingTrack() -> Track? {
        if !queueOfTracks.isEmpty {
            if queueOfTracks.indices.contains(nowPlayingIndex) {
                return queueOfTracks[nowPlayingIndex]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func getNowPlayingAvPlayerItem() -> AVPlayerItem {
        return avPlayerItems[nowPlayingIndex]
    }

    func getCurrentNowPlayableStaticMetadata() -> NowPlayableStaticMetadata? {
        let currentNowPlayableStaticMetadata = nowPlayableStaticMetadatas[nowPlayingIndex]
        return currentNowPlayableStaticMetadata
    }

    // MARK: - Queue Control Method

    // This methods shouldn't be called directly in view. View can control audio by AudioManager.
    func deleteAllTracksInQueue() {
        queueOfTracks.removeAll()
    }

    func addTracksAtEndofQueue(tracks: [Track]) {
        queueOfTracks.append(contentsOf: tracks)

        for track in tracks {
            let trackURL = StorageManager.shared.getActualTrackURL(track)
            avPlayerItems.append(AVPlayerItem(asset: AVURLAsset(url: trackURL), automaticallyLoadedAssetKeys: ["availableMediaCharacteristicsWithMediaSelectionOptions"]))

            guard let imageData = try? Data(contentsOf: StorageManager.shared.getActualTrackArtworkURL(track)) else { return }
            guard let image = UIImage(data: imageData) else { return }

            let artistNames = makeArtistAsString(track.artists)

            var albumArtist = "Unknown Artist"
            var albumTitle = "Unknown Album"

            if let album = track.album {
                albumArtist = makeArtistAsString(album.artist)
                albumTitle = album.title
            }
            let metadata = NowPlayableStaticMetadata(assetURL: track.audioLocalURL, mediaType: MPNowPlayingInfoMediaType.audio, isLiveStream: false, title: track.title, artist: artistNames, artwork: MPMediaItemArtwork(boundsSize: image.size) { _ in image }, albumArtist: albumArtist, albumTitle: albumTitle) // TODO: Support Multiple Artist
            nowPlayableStaticMetadatas.append(metadata)

            lenghtOfQueue += 1
        }
    }

    // func addTrackAtEndofQueue(track: Track) throws {}

    func doesNextTrackExist() -> Bool {
        if nowPlayingIndex < lenghtOfQueue - 1 {
            return true
        } else {
            return false
        }
    }

    func doesPreviousTrackExist() -> Bool {
        if nowPlayingIndex > 0 {
            return true
        } else {
            return false
        }
    }

    func handleNowPlayingItemMoveNext() {
        nowPlayingIndex += 1
    }

    func handleNowPlayingItemMovePrevious() {
        if nowPlayingIndex > 0 {
            nowPlayingIndex -= 1
        } else {
            nowPlayingIndex = 0
            NSLog("PlayableQueue: Can't go previous track. Now-playing track is the first track of queue.")
        }
    }

    // MARK: - Helper Method

    /// Return formatted string that display name of artists like "Dog, Cat, Cow"
    func makeArtistAsString(_ artists: [Artist]) -> String {
        if artists.isEmpty {
            return "Unknown Artist"
        }

        var artistNames = ""
        for (index, artist) in artists.enumerated() {
            artistNames.append(artist.name)
            if index < artists.count - 1 {
                artistNames.append(", ")
            }
        }
        return artistNames
    }
}
