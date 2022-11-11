//
//  MusicInfo.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import Foundation
import ShazamKit

struct MusicInfo {
    let title: String
    let artist: String
    let album: String
    let imageURL: URL
    
    init?(mediaItem: SHMatchedMediaItem) {
        guard let title = mediaItem.title,
              let artist = mediaItem.artist,
              let album = mediaItem.album,
              let imageURL = mediaItem.artworkURL else { return nil }
        
        self.title = title
        self.artist = artist
        self.album = album
        self.imageURL = imageURL
    }
}
