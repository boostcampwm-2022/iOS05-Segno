//
//  MusicInfo.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import Foundation

struct MusicInfo: Codable, Equatable {
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
    
    // 수동 더미
    init(isrc: String, title: String, artist: String, album: String, imageURL: String? = nil) {
        self.isrc = isrc
        self.title = title
        self.artist = artist
        self.album = album
        self.imageURL = imageURL
    }
}

#if DEBUG
extension MusicInfo {
    static let yokohama = MusicInfo(isrc: "JPF920900301", title: "Yokohama City", artist: "paris match", album: "Passion8", imageURL:  "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/1e/69/38/1e693867-a4e3-19a2-aba5-2a35eaed49a6/VEATP-37522.jpg/800x800bb.jpg")
}
#endif
