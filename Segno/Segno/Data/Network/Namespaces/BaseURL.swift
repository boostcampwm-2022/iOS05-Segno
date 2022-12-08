//
//  BaseURL.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/16.
//

import Foundation

enum BaseURL {
    static let urlString = "https://baero.me"
    
    static func getImageURL(imagePath: String) -> URL? {
        return URL(string: BaseURL.urlString)?
            .appendingPathComponent("image")
            .appendingPathComponent(imagePath)
    }
}
