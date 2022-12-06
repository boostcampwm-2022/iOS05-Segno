//
//  DiaryDetailDTO.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/23.
//

import Foundation

struct DiaryDetailDTO: Decodable {
    //TODO: MusicInfo, Location 추가 및 수정
    let id: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    
    init(id: String, title: String, tags: [String], imagePath: String, bodyText: String?, musicInfo: MusicInfo? = nil, location: Location? = nil) {
        self.id = id
        self.title = title
        self.tags = tags
        self.imagePath = imagePath
        self.bodyText = bodyText
        self.musicInfo = musicInfo
        self.location = location
    }
    
    #if DEBUG
    static let example = DiaryDetailDTO(
        id: "id",
        title: "title",
        tags: ["tag1", "tag2"],
        imagePath: "test.png",
        bodyText: "bodyText"
    )
    #endif
}
