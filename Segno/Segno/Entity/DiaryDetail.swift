//
//  DiaryDetail.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

// TODO: 코어 로케이션에서 좌표만 뽑아와서 저장하기
import CoreLocation

struct DiaryDetail {
    let identifier: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: CLLocation?
}
