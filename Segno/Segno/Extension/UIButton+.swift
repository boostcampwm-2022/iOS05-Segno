//
//  UIButton+.swift
//  Segno
//
//  Created by TaehoYoo on 2022/11/15.
//

import UIKit

import Kingfisher

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        setBackgroundImage(backgroundImage, for: state)
    }
    
    func setImage(urlString: String) {
        guard let imageURL = URL(string: urlString) else { return }
        let resource = ImageResource(downloadURL: imageURL, cacheKey: urlString)
        
        let memoryCache = KingfisherManager.shared.cache.memoryStorage
        memoryCache.config.expiration = .seconds(3600)
        
        kf.setImage(with: resource, for: .normal)
    }
}
