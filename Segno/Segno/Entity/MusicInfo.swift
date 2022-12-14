//
//  MusicInfo.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import Foundation

struct MusicInfo: Codable {
    let isrc: String
    let title: String
    let artist: String
    let album: String
    let imageURL: String?
    
    init(shazamSong: ShazamSongDTO) {
        self.isrc = shazamSong.isrc
        self.title = shazamSong.title
        self.artist = shazamSong.artist
        self.album = shazamSong.album
        self.imageURL = shazamSong.imageURL?.absoluteString
    }
}
