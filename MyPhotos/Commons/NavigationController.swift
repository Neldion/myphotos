//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {

  override var prefersStatusBarHidden: Bool {
    return topViewController?.prefersStatusBarHidden ?? false
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  override var prefersHomeIndicatorAutoHidden: Bool {
    return topViewController?.prefersHomeIndicatorAutoHidden ?? false
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    guard let presentingViewController = presentingViewController else {
      return UIDevice.current.userInterfaceIdiom == .phone ? .portrait : super.supportedInterfaceOrientations
    }
    return presentingViewController.supportedInterfaceOrientations
  }

  override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    guard let presentingViewController = presentingViewController else {
      return UIDevice.current.userInterfaceIdiom == .phone ?
        .portrait :
      super.preferredInterfaceOrientationForPresentation
    }
    return presentingViewController.preferredInterfaceOrientationForPresentation
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationController()
  }

  override func popViewController(animated: Bool) -> UIViewController? {
    if presentingViewController == nil {
      setupNavigationController()
    }
    return super.popViewController(animated: animated)
  }
}

extension UINavigationController {

  func setupNavigationController() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = .clear
    appearance.shadowImage = UIImage()
    appearance.backgroundColor = .white
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor.black,
      .font: UIFont.boldSystemFont(ofSize: 17.0),
      .kern: 0.4
    ]

    navigationController?.navigationItem.standardAppearance = appearance
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.isOpaque = true
  }
}
