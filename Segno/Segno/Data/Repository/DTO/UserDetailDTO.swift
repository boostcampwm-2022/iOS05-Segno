//
//  UserDetailDTO.swift
//  Segno
//
//  Created by 이예준 on 2022/11/30.
//

struct UserDetailDTO: Decodable {
    let nickname: String
    let email: String
    let oauthType: String
    let diaryCount: Int
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nickName"
        case email, oauthType, diaryCount
    }
}
