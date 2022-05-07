//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

struct MPImages: Decodable {
  let raw: URL?
  let full: URL?
  let regular: URL?
  let small: URL?
  let thumb: URL?
  let smallS3: URL?
  let medium: URL?
  let large: URL?
}
