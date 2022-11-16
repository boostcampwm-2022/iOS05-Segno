//
//  DiaryListDTO.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/15.
//

struct DiaryListDTO: Decodable {
    let data: [DiaryListItemDTO]
    
    #if DEBUG
    static let example = DiaryListDTO(data: [DiaryListItemDTO.exampleData1,
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
    // TODO: 일단은 다이어리 리스트 아이템과 동일하게 작성. 이후 서버 사이드에 따라 바꾸겠습니다.
    let id: String
    let title: String
    let thumbnailPath: String
    
    #if DEBUG
    static let exampleData1 = DiaryListItemDTO(id: "asdf", title: "예시 데이터1입니다.", thumbnailPath: "")
    static let exampleData2 = DiaryListItemDTO(id: "qwer", title: "예시 데이터2입니다.", thumbnailPath: "")
    static let exampleData3 = DiaryListItemDTO(id: "xzcv", title: "예시 데이터3입니다.", thumbnailPath: "")
    static let exampleData4 = DiaryListItemDTO(id: "hjkl", title: "예시 데이터4입니다.", thumbnailPath: "")
    static let exampleData5 = DiaryListItemDTO(id: "sdfg", title: "예시 데이터5입니다.", thumbnailPath: "")
    static let exampleData6 = DiaryListItemDTO(id: "wert", title: "예시 데이터6입니다.", thumbnailPath: "")
    static let exampleData7 = DiaryListItemDTO(id: "xcvb", title: "예시 데이터7입니다.", thumbnailPath: "")
    static let exampleData8 = DiaryListItemDTO(id: "ghjk", title: "예시 데이터8입니다.", thumbnailPath: "")
    #endif
}
