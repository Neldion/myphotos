//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

enum HomeScene {

  struct Response: Equatable {
    let home: Contents
  }

  struct ViewModel: Equatable {
    let title: String
    let posts: [Post]
  }

  class Post: NSObject {

    let identifier: String
    let picture: URL?
    let descriptionPost: String
    let likes: Int
    let isLiked: Bool
    let publicationDate: String?
    let avatar: URL?
    let username: String
    let socialUsername: String

    init(identifier: String,
         picture: URL?,
         descriptionPost: String,
         likes: Int,
         isLiked: Bool,
         publicationDate: String?,
         avatar: URL?,
         username: String,
         socialUsername: String) {
      self.identifier = identifier
      self.picture = picture
      self.descriptionPost = descriptionPost
      self.likes = likes
      self.isLiked = isLiked
      self.publicationDate = publicationDate
      self.avatar = avatar
      self.username = username
      self.socialUsername = socialUsername
      super.init()
    }

    @objc override var hash: Int {
      return identifier.hashValue
    }

    @objc override func isEqual(_ object: Any?) -> Bool {
      guard let rhs = object as? Post else { return false }
      return self.identifier == rhs.identifier
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
      return lhs.isEqual(rhs)
    }
  }
}
