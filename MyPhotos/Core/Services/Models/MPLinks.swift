//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

struct MPLinks: Decodable {
  enum CodingKeys: String, CodingKey {
      case html, download
      case downloadLocation = "download_location"
      case link = "self"
  }

  let link: String?
  let html: String?
  let download: String?
  let downloadLocation: String?
}
