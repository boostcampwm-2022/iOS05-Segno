//
//  MusicInfo.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import Foundation
import ShazamKit

struct MusicInfo: Encodable {
    let isrc: String
    let title: String
    let artist: String
    let album: String
    let imageURL: URL?
    
    init?(mediaItem: SHMatchedMediaItem) {
        guard let isrc = mediaItem.isrc,
              let title = mediaItem.title,
              let artist = mediaItem.artist,
              let album = mediaItem.album else { return nil }
        
        self.isrc = isrc
        self.title = title
        self.artist = artist
        self.album = album
        self.imageURL = mediaItem.artworkURL
    }
}
