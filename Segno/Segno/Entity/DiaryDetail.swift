//
//  DiaryDetail.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import CoreLocation

struct DiaryDetail {
    let id: String
    let title: String
    let tags: [String]
    let imagePath: String
    let bodyText: String?
    let musicInfo: MusicInfo?
    let location: CLLocation?
}
