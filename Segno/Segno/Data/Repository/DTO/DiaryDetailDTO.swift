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
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    
    init(id: String,
         userId: String,
         title: String,
         tags: [String],
         imagePath: String,
         bodyText: String? = nil,
         musicInfo: MusicInfo? = nil,
         location: Location? = nil) {
        self.id = id
        self.userId = userId
        self.title = title
        self.tags = tags
        self.imagePath = imagePath
        self.bodyText = bodyText
        self.musicInfo = musicInfo
        self.location = location
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, title, tags, imagePath, bodyText, musicInfo, location
    }
    
    #if DEBUG
    static let example = DiaryDetailDTO(
        id: "id",
        userId: "userId",
        title: "title",
        tags: ["tag1", "tag2"],
        imagePath: "test.png",
        bodyText: "bodyText"
    )
    #endif
}
