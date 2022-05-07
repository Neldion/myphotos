//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

struct MPStatistics: Decodable {
  let id: String
  let downloads: MPData?
  let views: MPData?

  struct MPData: Decodable {
    let total: Int?
  }
}
