//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol HomeWorkerLogic {
  func fetch() async -> Result<Contents, Error>
  func like(id: String, shouldLike: Bool) async -> Result<Void, Error>
}

final class HomeWorker: HomeWorkerLogic {

  private let service: HomeService

  init(service: HomeService) {
    self.service = service
  }

  func fetch() async -> Result<Contents, Error> {
    return await service.fetch()
  }

  func like(id: String, shouldLike: Bool) async -> Result<Void, Error> {
    return await service.like(id: id, shouldLike: shouldLike)
  }
}
