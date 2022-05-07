//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

protocol HomeRoutingLogic {
  func routeToDetail()
}

protocol HomeDataPassing {
  var dataStore: HomeDataStore { get set }
}

typealias HomeRoutingProtocol = HomeRoutingLogic & HomeDataPassing

final class HomeRouter: HomeRoutingProtocol {

  var dataStore: HomeDataStore
  private weak var viewController: HomeViewController?

  init(viewController: HomeViewController, dataStore: HomeDataStore) {
    self.viewController = viewController
    self.dataStore = dataStore
  }

  func routeToDetail() {
    guard let post = dataStore.selectedPost,
          let destination = container.resolve(DetailsViewController.self) else { return }
    destination.router?.dataStore.post = post
    if UIDevice.current.userInterfaceIdiom == .phone {
      viewController?.navigationController?.pushViewController(destination, animated: true)
    } else {
      let navigationController = NavigationController(rootViewController: destination)
      viewController?.present(navigationController, animated: true)
    }
  }
}
