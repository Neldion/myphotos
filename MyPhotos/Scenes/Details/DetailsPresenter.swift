//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol DetailsPresentationLogic {
  func present(response: DetailsScene.Response)
  func present(error: Error)
}

final class DetailsPresenter: DetailsPresentationLogic {

  private weak var display: DetailsDisplayLogic?

  init(display: DetailsDisplayLogic?) {
    self.display = display
  }

  func present(response: DetailsScene.Response) {
    guard let post = response.post, let statistics = response.statistics else { return }

    let userInfos = DetailsScene.UserInfos(avatar: post.user.avatar,
                                           username: post.user.name,
                                           socialUsername: "@\(post.user.socialUsername)")

    let header = DetailsScene.Header(bigPicture: post.bigPicture,
                                     description: post.description,
                                     likes: post.likes,
                                     isLiked: post.isLiked,
                                     views: statistics.views,
                                     downloads: statistics.downloads)

    let pictures = response.contents?.posts.compactMap {
      return DetailsScene.Picture(identifier: $0.identifier, url: $0.smallPicture)
    }

    let viewModel = DetailsScene.ViewModel(userInfos: userInfos, header: header, pictures: pictures ?? [])
    display?.display(viewModel: viewModel)
  }

  func present(error: Error) {
    display?.display(error: error)
  }
}
