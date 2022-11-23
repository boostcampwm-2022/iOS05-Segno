//
//  DiaryDetailDTO.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/23.
//

import Foundation

struct DiaryDetailDTO: Decodable {
    let id: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: String?
    
    #if DEBUG
    static let example = DiaryDetailDTO(
        id: "id",
        title: "title",
        tags: ["tag1", "tag2"],
        imagePath: "test.png",
        bodyText: "bodyText",
        musicInfo: "music"
    )
    #endif
}
