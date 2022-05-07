//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol DetailWorkerLogic {
  func fetch(using url: String) async -> Result<Statistics, Error>
  func fetchUserDetail(using username: String) async -> Result<Contents, Error>
}

final class DetailWorker: DetailWorkerLogic {

  private let service: DetailService

  init(service: DetailService) {
    self.service = service
  }

  func fetch(using url: String) async -> Result<Statistics, Error> {
    return await service.fetch(using: url)
  }

  func fetchUserDetail(using username: String) async -> Result<Contents, Error> {
    return await service.fetchUserDetail(using: username)
  }
}
