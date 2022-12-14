//
//  UIImageView+.swift
//  Segno
//
//  Created by Gordon Choi on 2022/12/12.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(imagePath: String) {
        guard let imageURL = BaseURL.getImageURL(imagePath: imagePath) else { return }
        let resource = ImageResource(downloadURL: imageURL, cacheKey: imagePath)
        
        let memoryCache = KingfisherManager.shared.cache.memoryStorage
        memoryCache.config.expiration = .seconds(3600)
        
        kf.setImage(with: resource)
    }
    
    func setImage(urlString: String) {
        guard let imageURL = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: imageURL, cacheKey: urlString)
        
        let memoryCache = KingfisherManager.shared.cache.memoryStorage
        memoryCache.config.expiration = .seconds(3600)
        
        kf.setImage(with: resource)
    }
}
