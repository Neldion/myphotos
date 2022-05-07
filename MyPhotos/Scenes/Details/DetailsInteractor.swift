//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol DetailsBusinessLogic {
  func fetch() async
}

protocol DetailsDataStore {
  var post: Post? { get set }
}

final class DetailsInteractor: DetailsBusinessLogic, DetailsDataStore {

  var post: Post?
  var contents: Contents?
  var statistics: Statistics?
  private let presenter: DetailsPresentationLogic
  private let worker: DetailWorkerLogic

  init(presenter: DetailsPresentationLogic, worker: DetailWorkerLogic) {
    self.presenter = presenter
    self.worker = worker
  }

  func fetch() async {
    guard let url = post?.detailUrl, let user = post?.user else { return }

    async let statsResult = worker.fetch(using: url)
    async let contentsResult = worker.fetchUserDetail(using: user.name)
    _ = await [statsResult, contentsResult]

    switch await statsResult {
    case .success(let statistics):
      self.statistics = statistics
    case .failure(let error):
      presenter.present(error: error)
    }

    switch await contentsResult {
    case .success(let contents):
      self.contents = contents
    case .failure(let error):
      presenter.present(error: error)
    }

    let response = DetailsScene.Response(contents: contents, statistics: statistics, post: post)
    presenter.present(response: response)
  }
}
