//
//  UIImageView+.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/12.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(from imagePath: String) {
        guard let imageURL = BaseURL.getImageURL(imagePath: imagePath) else { return }
        let resource = ImageResource(downloadURL: imageURL, cacheKey: imagePath)
        
        let memoryCache = KingfisherManager.shared.cache.memoryStorage
        memoryCache.config.expiration = .seconds(3600)
        
        self.kf.setImage(with: resource)
    }
}
