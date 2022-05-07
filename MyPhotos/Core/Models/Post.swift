//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

struct Post: Equatable {
  let identifier: String
  let smallPicture: URL?
  let bigPicture: URL?
  let description: String
  var likes: Int
  var isLiked: Bool
  let publicationDate: String?
  let user: User
  let detailUrl: String?
}
