//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

struct MPUser: Decodable {
  let id: String
  let username: String?
  let bio: String?
  let profileImage: MPImages?
  let social: MPSocial?

  struct MPSocial: Decodable {
    let instagramUsername: String?
    let twitterUsername: String?
  }
}
