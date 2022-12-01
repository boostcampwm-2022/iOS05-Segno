//
//  UserDetailDTO.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

struct UserDetailDTO: Decodable {
    // TODO: 일단은 UserDetailItem과 동일하게 작성. 이후 서버 사이드에 따라 바꾸겠습니다.
    let identifier: String
    let nickname: String
    let writtenDiary: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "_id"
        case nickname
        case writtenDiary = "diary"
    }
    
    #if DEBUG
    static let example = UserDetailDTO(
        identifier: "id",
        nickname: "test123",
        writtenDiary: "50000"
    )
    #endif
}
