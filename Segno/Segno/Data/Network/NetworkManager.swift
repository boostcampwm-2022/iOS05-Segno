//
//  NetworkManager.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/14.
//

import Foundation
import RxSwift

struct NetworkManager {
    static let shared = NetworkManager()
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func call(_ endpoint: Endpoint) -> Single<Data> {
        guard let request = try? endpoint.toURLRequest() else {
            return Single.create { observer -> Disposable in
                observer(.failure(NetworkError.failedToCreateRequest))
                
                return Disposables.create()
            }
        }
        
        return call(request)
    }
    
    private func call(_ request: URLRequest) -> Single<Data> {
        return Single.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    observer(.failure(NetworkError.unknownNetworkError))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer(.failure(NetworkError.failedToGetHTTPResponse))
                    return
                }
                
                guard let data else {
                    observer(.failure(NetworkError.failedToGetData))
                    return
                }
                
                if (200...299) ~= httpResponse.statusCode {
                    observer(.success(data))
                } else {
                    // TODO: 서버에서 설정하는 에러 코드에 따라 에러 메시지 다르게 설정
                    observer(.failure(NetworkError.invalidNetworkStatusCode))
                }
            }
            
            task.resume()
            return Disposables.create()
        }
    }
}
