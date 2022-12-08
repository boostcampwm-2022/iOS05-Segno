//
//  DiaryDetail.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

struct DiaryDetail: Encodable {
    let identifier: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: Location?
    
    var token: String?
    
    init(identifier: String, title: String, tags: [String], imagePath: String, bodyText: String?, musicInfo: MusicInfo?, location: Location?, token: String? = nil) {
        self.identifier = identifier
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

#if DEBUG
extension DiaryDetail {
    static let dummy = DiaryDetail(identifier: "1", title: "테스트", tags: ["테스트"], imagePath: "", bodyText: "테스트", musicInfo: MusicInfo.yokohama, location: nil)
}
#endif
