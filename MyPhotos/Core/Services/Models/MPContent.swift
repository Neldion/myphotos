//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

struct MPContent: Decodable {
  let id: String
  let createdAt: String?
  let updatedAt: String?
  let width: Int?
  let height: Int?
  let urls: MPImages?
  let links: MPLinks?
  let likes: Int?
  let likedByUser: Bool?
  let description: String?
  let user: MPUser
}
