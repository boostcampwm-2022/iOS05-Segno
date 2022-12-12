//
//  DiaryListDTO.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

struct DiaryListDTO: Decodable {
    let diaries: [DiaryListItemDTO]
}

struct DiaryListItemDTO: Decodable {
    let identifier: String
    let title: String
    let thumbnailPath: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
        case title
        case thumbnailPath = "imagePath"
    }
}
