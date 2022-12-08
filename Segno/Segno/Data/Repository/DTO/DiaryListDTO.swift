//
//  DiaryListDTO.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

struct DiaryListDTO: Decodable {
    let diaries: [DiaryListItemDTO]
    
    #if DEBUG
    static let example = DiaryListDTO(diaries: [DiaryListItemDTO.exampleData1,
                                             DiaryListItemDTO.exampleData2,
                                             DiaryListItemDTO.exampleData3,
                                             DiaryListItemDTO.exampleData4,
                                             DiaryListItemDTO.exampleData5,
                                             DiaryListItemDTO.exampleData6,
                                             DiaryListItemDTO.exampleData7,
                                             DiaryListItemDTO.exampleData8])
    #endif
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
    
    #if DEBUG
    static let exampleData1 = DiaryListItemDTO(identifier: "asdf", title: "예시 데이터1입니다.", thumbnailPath: "")
    static let exampleData2 = DiaryListItemDTO(identifier: "qwer", title: "예시 데이터2입니다.", thumbnailPath: "")
    static let exampleData3 = DiaryListItemDTO(identifier: "xzcv", title: "예시 데이터3입니다.", thumbnailPath: "")
    static let exampleData4 = DiaryListItemDTO(identifier: "hjkl", title: "예시 데이터4입니다.", thumbnailPath: "")
    static let exampleData5 = DiaryListItemDTO(identifier: "sdfg", title: "테스트 데이터1입니다.", thumbnailPath: "")
    static let exampleData6 = DiaryListItemDTO(identifier: "wert", title: "테스트 데이터2입니다.", thumbnailPath: "")
    static let exampleData7 = DiaryListItemDTO(identifier: "xcvb", title: "테스트 데이터3입니다.", thumbnailPath: "")
    static let exampleData8 = DiaryListItemDTO(identifier: "ghjk", title: "테스트 데이터4입니다.", thumbnailPath: "")
    #endif
}
