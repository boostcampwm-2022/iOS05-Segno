//
//  Endpoint.swift
//  Segno
//
//  Created by Gordon Choi on 2022/11/14.
//

import Foundation

typealias Headers = [String: String]
typealias Queries = [String: String]
typealias Body = Encodable

// MARK: HTTP 요청 메서드
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

// MARK: 요청 파라미터
enum HTTPRequestParameter {
    case queries(Queries)
    case body(Body)
    case data(Data)
}

// MARK: Endpoint 본체
protocol Endpoint {
    var baseURL: URL? { get }
    var httpMethod: HTTPMethod { get }
    var headers: Headers { get }
    var path: String { get }
    var parameters: HTTPRequestParameter? { get }
    
    func toURLRequest() throws -> URLRequest
}

extension Endpoint {
    var headers: Headers {
        switch self.parameters {
        case .data(_):
            return ["Content-Type": "multipart/form-data; boundary=SEGNO"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    func toURLRequest() throws -> URLRequest {
        guard let url = configureURL() else {
            throw NetworkError.failedToCreateURL
        }
        
        return URLRequest(url: url)
            .setMethod(httpMethod)
            .appendingHeaders(headers)
            .setBody(at: parameters)
    }
    
    private func configureURL() -> URL? {
        return baseURL?
            .appendingPath(path)
            .appendingQueries(at: parameters)
    }
}

fileprivate extension URL {
    func appendingPath(_ path: String) -> URL {
        return self.appendingPathComponent(path)
    }
    
    func appendingQueries(at parameter: HTTPRequestParameter?) -> URL {
        var components = URLComponents(string: self.absoluteString)
        
        if case .queries(let queries) = parameter {
            components?.queryItems = queries.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        // 중간 과정이 잘못되었다면, self URL을 그대로 리턴한다.
        // 강제 언래핑을 회피하기 위한 과정
        return components?.url ?? self
    }
}

fileprivate extension URLRequest {
    func setMethod(_ method: HTTPMethod) -> URLRequest {
        var urlRequest = self
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    func appendingHeaders(_ headers: Headers) -> URLRequest {
        var urlRequest = self
        headers.forEach {
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        }
        
        return urlRequest
    }
    
    func setBody(at parameter: HTTPRequestParameter?) -> URLRequest {
        var urlRequest = self
        if case .body(let body) = parameter {
            urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        
        return urlRequest
    }
}
