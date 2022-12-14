//
//  UpdateDiaryDetail.swift
//  Segno
//
//  Created by 이예준 on 2022/12/13.
//

struct UpdateDiaryDetail: Encodable {
    let id: String
    let date: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    let token: String
    
    init(id: String,
         date: String,
         title: String,
         tags: [String],
         imagePath: String,
         bodyText: String?,
         musicInfo: MusicInfo?,
         location: Location?,
         token: String) {
        self.id = id
        self.date = date
        self.title = title
        self.tags = tags
        self.imagePath = imagePath
        self.bodyText = bodyText
        self.musicInfo = musicInfo
        self.location = location
        self.token = token
    }
}
