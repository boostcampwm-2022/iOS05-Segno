//
//  SHMediaItem+.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/10.
//

import ShazamKit

extension SHMediaItemProperty {
    static let album = SHMediaItemProperty("sh_albumName")
}

extension SHMediaItem {
    var album: String? {
        return self[.album] as? String
    }
}
