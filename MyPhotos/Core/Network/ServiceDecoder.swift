//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol ServiceDecoder {
  func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T
}

struct DefaultServiceDecoder: ServiceDecoder {

  init() { }

  private var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
    return try decoder.decode(type, from: data)
  }
}
