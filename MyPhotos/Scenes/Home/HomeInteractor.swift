//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

protocol HomeBusinessLogic {
  func fetch() async
  func selectItem(at index: Int)
  func like(at index: Int) async
}

protocol HomeDataStore {
  var selectedPost: Post? { get set }
}

final class HomeInteractor: HomeBusinessLogic, HomeDataStore {

  var home: Contents?
  var selectedPost: Post?
  private let presenter: HomePresentationLogic
  private let worker: HomeWorkerLogic

  init(presenter: HomePresentationLogic, worker: HomeWorkerLogic) {
    self.presenter = presenter
    self.worker = worker
  }

  func fetch() async {
    switch await worker.fetch() {
    case .success(let home):
      self.home = home
      presenter.present(response: HomeScene.Response(home: home))
    case .failure(let error):
      presenter.present(error: error)
    }
  }

  func selectItem(at index: Int) {
    guard let post = home?.posts[safe: index] else { return }
    selectedPost = post
    presenter.presentDetail()
  }

  func like(at index: Int) async {
    guard var home = home, var post = home.posts[safe: index] else { return }
    if post.isLiked {
      post.likes -= 1
    } else {
      post.likes += 1
    }
    post.isLiked.toggle()
    home.posts[index] = post
    self.home = home
    presenter.present(response: HomeScene.Response(home: home))

    if case .failure(let error) = await worker.like(id: post.identifier, shouldLike: post.isLiked) {
      post.isLiked.toggle()
      if post.isLiked {
        post.likes += 1
      } else {
        post.likes -= 1
      }
      home.posts[index] = post
      self.home = home
      presenter.present(response: HomeScene.Response(home: home))
      presenter.present(error: error)
    }
  }
}
