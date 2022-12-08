//
//  NewDiaryDetailDTO.swift
//  Segno
//
//  Created by YOONJONG on 2022/12/08.
//

struct NewDiaryDetailDTO: Decodable {
    let token: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    
    init(title: String, tags: [String], imagePath: String, bodyText: String?, musicInfo: MusicInfo?, location: Location?, token: String) {
        self.title = title
        self.tags = tags
        self.imagePath = imagePath
        self.bodyText = bodyText
        self.musicInfo = musicInfo
        self.location = location
        self.token = token
    }
}
