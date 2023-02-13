//
//  CheckSubscriptionSession.swift
//  Segno
//
//  Created by Gordon Choi on 2023/02/14.
//

import StoreKit

import RxSwift

final class CheckSubscriptionSession {
    func isSubscribedToAppleMusic() -> Single<Bool> {
        let serviceController = SKCloudServiceController()
        
        return Single.create { observer in
            serviceController.requestCapabilities { capabilities, error in
                if let error = error {
                    observer(.failure(error))
                } else {
                    if capabilities.contains(.musicCatalogPlayback) {
                        observer(.success(true))
                    } else {
                        observer(.success(false))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
