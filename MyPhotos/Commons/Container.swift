//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

extension Container {

  func setup() -> Container {
    registerNetwork()
    registerServices()
    registerWorkers()
    registerScenes()
    return self
  }

  private func registerNetwork() {
    autoregister(NetworkClient.self, initializer: DefaultNetworkClient.init).inObjectScope(.container)
  }

  private func registerServices() {
    autoregister(DetailService.self, initializer: DefaultDetailService.init)
    autoregister(HomeService.self, initializer: DefaultHomeService.init)
  }

  private func registerWorkers() {
    autoregister(DetailWorkerLogic.self, initializer: DetailWorker.init)
    autoregister(HomeWorkerLogic.self, initializer: HomeWorker.init)
  }

  private func registerScenes() {
    registerHome()
    registerDetails()
  }

  private func registerHome() {
    register(HomeViewController.self) { resolver in
      let controller = HomeViewController()
      let presenter = HomePresenter(display: controller)
      let worker = resolver.resolve(HomeWorkerLogic.self)!
      let interactor = HomeInteractor(presenter: presenter, worker: worker)
      let router = HomeRouter(viewController: controller, dataStore: interactor)
      controller.inject(interactor: interactor, router: router)
      return controller
    }
  }

  private func registerDetails() {
    register(DetailsViewController.self) { resolver in
      let controller = DetailsViewController()
      let presenter = DetailsPresenter(display: controller)
      let worker = resolver.resolve(DetailWorkerLogic.self)!
      let interactor = DetailsInteractor(presenter: presenter, worker: worker)
      let router = DetailsRouter(viewController: controller, dataStore: interactor)
      controller.inject(interactor: interactor, router: router)
      return controller
    }
  }
}
