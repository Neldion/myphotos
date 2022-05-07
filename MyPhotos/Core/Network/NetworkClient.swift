//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol NetworkClient {
  func request(url: URL, method: URLRequest.HTTPMethod) async throws -> (Data, URLResponse)
}

final class DefaultNetworkClient: NetworkClient {

  func request(url: URL, method: URLRequest.HTTPMethod) async throws -> (Data, URLResponse) {
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = ["Authorization": "Client-ID HUVgFITKS-u2m8eqyWYmodQlQksbWpzJBA5Lay_6blk"]
    return try await session.data(for: request)
  }
}

extension URLRequest {
  enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
  }
}
