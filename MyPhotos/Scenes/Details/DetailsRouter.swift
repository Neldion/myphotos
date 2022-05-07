//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

protocol DetailsRoutingLogic {
  func routeToNext()
}

protocol DetailsDataPassing {
  var dataStore: DetailsDataStore { get set }
}

typealias DetailsRoutingProtocol = DetailsRoutingLogic & DetailsDataPassing

final class DetailsRouter: DetailsRoutingProtocol {

  var dataStore: DetailsDataStore
  private weak var viewController: DetailsViewController?

  init(viewController: DetailsViewController, dataStore: DetailsDataStore) {
    self.viewController = viewController
    self.dataStore = dataStore
  }

  func routeToNext() { }
}
