//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol HomePresentationLogic {
  func present(response: HomeScene.Response)
  func present(error: Error)
  func presentDetail()
}

final class HomePresenter: HomePresentationLogic {

  private weak var display: HomeDisplayLogic?

  init(display: HomeDisplayLogic?) {
    self.display = display
  }

  func present(response: HomeScene.Response) {
    let posts = response.home.posts.compactMap {
      return HomeScene.Post(identifier: $0.identifier,
                            picture: $0.smallPicture,
                            descriptionPost: $0.description,
                            likes: $0.likes,
                            isLiked: $0.isLiked,
                            publicationDate: $0.publicationDate,
                            avatar: $0.user.avatar,
                            username: $0.user.name,
                            socialUsername: "@\($0.user.socialUsername)")
    }
    display?.display(viewModel: HomeScene.ViewModel(title: L10n.Title.app, posts: posts))
  }

  func present(error: Error) {
    if let error = error as? HomeServiceError {
      switch error {
      case .parsingError:
        display?.display(error: L10n.Error.api)
      case .endPointError:
        display?.display(error: L10n.Error.api)
      case .likeError:
        display?.display(error: L10n.Error.like)
      case .homeError:
        display?.display(error: L10n.Error.api)
      }
    } else {
      display?.display(error: error.localizedDescription)
    }
  }

  func presentDetail() {
    display?.displayDetail()
  }
}
