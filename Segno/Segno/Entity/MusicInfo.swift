//
//  MusicInfo.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import Foundation

struct MusicInfo: Encodable {
    let isrc: String
    let title: String
    let artist: String
    let album: String
    let imageURL: URL?
    
    init(shazamSong: ShazamSong) {
        self.isrc = shazamSong.isrc
        self.title = shazamSong.title
        self.artist = shazamSong.artist
        self.album = shazamSong.album
        self.imageURL = shazamSong.imageURL
    }
}
