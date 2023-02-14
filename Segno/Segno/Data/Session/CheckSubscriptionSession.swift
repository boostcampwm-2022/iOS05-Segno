//
//  CheckSubscriptionSession.swift
//  Segno
//
//  Created by Gordon Choi on 2023/02/14.
//

import StoreKit

import RxSwift

final class CheckSubscriptionSession {
    func isSubscribedToAppleMusic() -> Completable {
        let serviceController = SKCloudServiceController()
        
        return Completable.create { observer in
            serviceController.requestCapabilities { capabilities, error in
                if error != nil {
                    observer(.error(MusicError.failedToCheckAuthorization))
                } else {
                    if capabilities.contains(.musicCatalogPlayback) {
                        observer(.completed)
                    } else {
                        observer(.error(MusicError.notAuthorized))
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
