//
//  DiaryDetailDTO.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/23.
//

import Foundation

struct DiaryDetailDTO: Decodable {
    let id: String
    let userId: String
    let date: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    
    init(id: String,
         userId: String,
         date: String,
         title: String,
         tags: [String],
         imagePath: String,
         bodyText: String? = nil,
         musicInfo: MusicInfo? = nil,
         location: Location? = nil) {
        self.id = id
        self.userId = userId
        self.date = date
        self.title = title
        self.tags = tags
        self.imagePath = imagePath
        self.bodyText = bodyText
        self.musicInfo = musicInfo
        self.location = location
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, date, title, tags, imagePath, bodyText, musicInfo, location
    }
}
