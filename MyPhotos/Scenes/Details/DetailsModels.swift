//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

enum DetailsScene {

  struct Request: Equatable { }

  struct Response: Equatable {
    var contents: Contents?
    var statistics: Statistics?
    var post: Post?
  }

  struct ViewModel: Equatable {
    let userInfos: UserInfos
    let header: Header
    let pictures: [Picture]
  }

  struct UserInfos: Equatable {
    let avatar: URL?
    let username: String
    let socialUsername: String
  }

  struct Header: Equatable {
    let bigPicture: URL?
    let description: String
    let likes: Int
    let isLiked: Bool
    let views: Int
    let downloads: Int
  }

  class Picture: NSObject {

    let identifier: String
    let url: URL?

    init(identifier: String,
         url: URL?) {
      self.identifier = identifier
      self.url = url
      super.init()
    }

    @objc override var hash: Int {
      return identifier.hashValue
    }

    @objc override func isEqual(_ object: Any?) -> Bool {
      guard let rhs = object as? Post else { return false }
      return self.identifier == rhs.identifier
    }

    static func == (lhs: Picture, rhs: Picture) -> Bool {
      return lhs.isEqual(rhs)
    }
  }
}
