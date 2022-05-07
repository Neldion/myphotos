//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
  func display(viewModel: HomeScene.ViewModel)
  func display(error: String)
  func displayDetail()
}

final class HomeViewController: UIViewController {

  var router: HomeRoutingProtocol?

  private var interactor: HomeBusinessLogic?
  private var viewModel: HomeScene.ViewModel?
  private lazy var flowLayout = UICollectionViewFlowLayout()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.register(PostCell.self, forCellWithReuseIdentifier: String(describing: PostCell.self))
    collectionView.contentInset = UIEdgeInsets(top: 16, left: .zero, bottom: 16, right: .zero)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  func inject(interactor: HomeBusinessLogic?, router: HomeRoutingProtocol?) {
    self.interactor = interactor
    self.router = router
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupInterface()
    setupConstraints()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateNavigationBarIfNeeded(collectionView.contentOffset)
    Task {
      await interactor?.fetch()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeShadow()
  }

  private func setupNavigationBar() {
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

  private func setupInterface() {
    view.backgroundColor = .white
    view.addSubview(collectionView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

extension HomeViewController: HomeDisplayLogic {

  func display(viewModel: HomeScene.ViewModel) {
    Task { @MainActor in
      self.viewModel = viewModel
      navigationItem.title = viewModel.title
      collectionView.reloadData()
    }
  }

  func display(error: String) {
    Task { @MainActor in
      let alert = UIAlertController(title: L10n.Alert.title,
                                    message: error,
                                    preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: L10n.Alert.closeButton, style: .cancel, handler: nil))
      present(alert, animated: true)
    }
  }

  func displayDetail() {
    router?.routeToDetail()
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    interactor?.selectItem(at: indexPath.item)
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    updateNavigationBarIfNeeded(scrollView.contentOffset)
  }

  private func updateNavigationBarIfNeeded(_ contentOffset: CGPoint) {
    if contentOffset.y > 8 {
      setupShadow(contentOffset: contentOffset.y)
    } else {
      removeShadow()
    }
  }
  private func setupShadow(contentOffset: CGFloat) {
    if navigationController?.navigationBar.layer.shadowColor == nil {
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [self] in
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
        navigationController?.navigationBar.layer.shadowRadius = 3.0
        navigationController?.navigationBar.setNeedsLayout()
      }, completion: nil)
    }
  }

  private func removeShadow() {
    if navigationController?.navigationBar.layer.shadowColor != nil {
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [self] in
        navigationController?.navigationBar.layer.shadowColor = nil
        navigationController?.navigationBar.layer.shadowOffset = .zero
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationController?.navigationBar.layer.shadowRadius = 0
        navigationController?.navigationBar.setNeedsLayout()
      }, completion: nil)
    }
  }
}

extension HomeViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let post = viewModel?.posts[safe: indexPath.item],
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PostCell.self),
                                                        for: indexPath) as? PostCell else { fatalError() }
    cell.setup(with: post, delegate: self)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.posts.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let post = viewModel?.posts[safe: indexPath.item] else { return .zero }
    let postHeight = PostCell.size(for: post, for: collectionView.frame.size.width).height
    return CGSize(width: collectionView.frame.size.width - 24, height: postHeight)
  }
}

extension HomeViewController: PostCellDelegate {

  func didTapLike(in cell: PostCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    Task {
      await interactor?.like(at: indexPath.item)
    }
  }
}
