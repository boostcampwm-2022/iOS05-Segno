//
//  DiaryDetail.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

struct DiaryDetail: Encodable, Equatable {
    let identifier: String
    let userId: String
    let title: String
    let date: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    
    var token: String?
    
    init(identifier: String, userId: String, date: String, title: String, tags: [String], imagePath: String, bodyText: String?, musicInfo: MusicInfo?, location: Location?, token: String? = nil) {
        self.identifier = identifier
        self.userId = userId
        self.date = date
        self.title = title
        self.tags = tags
        self.imagePath = imagePath
        self.bodyText = bodyText
        self.musicInfo = musicInfo
        self.location = location
        self.token = token
    }
    
    init(_ diary: DiaryDetail, imagePath: String) {
        self.init(
            identifier: diary.identifier,
            userId: diary.userId,
            date: diary.date,
            title: diary.title,
            tags: diary.tags,
            imagePath: imagePath,
            bodyText: diary.bodyText,
            musicInfo: diary.musicInfo,
            location: diary.location,
            token: diary.token
        )
    }
    
    // DUMMY
    init(_ diary: DiaryDetail, token: String) {
        self.init(
            identifier: diary.identifier,
            userId: diary.userId,
            date: diary.date,
            title: diary.title,
            tags: diary.tags,
            imagePath: diary.imagePath,
            bodyText: diary.bodyText,
            musicInfo: diary.musicInfo,
            location: diary.location,
            token: token
        )
    }
}
