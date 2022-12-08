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
        switch endpoint.parameters {
        case .data(let data):
            return call(request, type: .uploadTask, data: buildDataBody(data))
        default:
            return call(request)
        }
    }
    
    private func call(_ request: URLRequest, type: SessionType = .dataTask, data: Data? = nil) -> Single<Data> {
        Single.create { observer -> Disposable in
            let completeHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
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
                    observer(.failure(NetworkError.invalidNetworkStatusCode))
                }
            }
            
            let task = {
                switch type {
                case .dataTask:
                    return URLSession.shared.dataTask(with: request, completionHandler: completeHandler)
                case .uploadTask:
                    return URLSession.shared.uploadTask(with: request, from: data, completionHandler: completeHandler)
                }
            }()
            
            task.resume()
            return Disposables.create()
        }
    }
    
    func buildDataBody(_ data: Data) -> Data? {
        let boundary = "SEGNO"
        let headerLines = [
          "--\(boundary)",
          "Content-Disposition: form-data; name=\"image\"; filename=\"testImage\"",
          "Content-Type: image/png",
          "\r\n"
        ]
        var body = headerLines.joined(separator: "\r\n").data(using: .utf8)!
        body.append(contentsOf: data)
        body.append(contentsOf: "\r\n--\(boundary)--".data(using: .utf8)!)
        
        return body
    }
    
    enum SessionType {
        case dataTask
        case uploadTask
    }
}
