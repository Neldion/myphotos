//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

protocol DetailsDisplayLogic: AnyObject {
  func display(viewModel: DetailsScene.ViewModel)
  func display(error: Error)
}

final class DetailsViewController: UIViewController, UIGestureRecognizerDelegate {

  var router: DetailsRoutingProtocol?
  private var interactor: DetailsBusinessLogic?
  private var viewModel: DetailsScene.ViewModel?
  private var headerHeight: CGFloat = 0

  private lazy var backButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: AppAssets.back.image,
                                 style: .plain,
                                 target: self,
                                 action: #selector(didTapBack))
    button.tintColor = .black
    return button
  }()

  private lazy var userView: UserView = {
    let view = UserView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var headerView: HeaderDetailView = {
    let view = HeaderDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: generateCompositionLayout())
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    view.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                  withReuseIdentifier: String(describing: SectionHeader.self))
    view.register(PictureCell.self, forCellWithReuseIdentifier: String(describing: PictureCell.self))
    view.delegate = self
    return view
  }()

  private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, DetailsScene.Picture> = {
    // swiftlint:disable:next line_length
    let dataSource = UICollectionViewDiffableDataSource<Int, DetailsScene.Picture>(collectionView: collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: DetailsScene.Picture) -> UICollectionViewCell? in
      guard let picture = self?.viewModel?.pictures[safe: indexPath.item],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PictureCell.self),
                                                          for: indexPath) as? PictureCell
      else { fatalError() }
      cell.setup(picture: picture.url)
      return cell
    }

    dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
      guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
          ofKind: elementKind,
          withReuseIdentifier: String(describing: SectionHeader.self),
          for: indexPath) as? SectionHeader else { fatalError("Cannot create section header") }
      supplementaryView.setup(with: "Same author")
      return supplementaryView
    }

    return dataSource
  }()

  func inject(interactor: DetailsBusinessLogic?, router: DetailsRoutingProtocol?) {
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
    Task {
      await interactor?.fetch()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if UIDevice.current.userInterfaceIdiom == .phone {
      navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
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
    if UIDevice.current.userInterfaceIdiom == .phone {
      navigationItem.setLeftBarButtonItems([backButton], animated: true)
    }
    view.backgroundColor = .white
    view.addSubview(headerView)
    view.addSubview(collectionView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
      headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  @objc
  private func didTapBack() {
    navigationController?.popViewController(animated: true)
  }

  private func generateCompositionLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
      let fractionnalItemWidth: CGFloat = 1 / 2
      let imageHeight = fractionnalItemWidth
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionnalItemWidth),
                                            heightDimension: .fractionalHeight(1))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                             heightDimension: .fractionalWidth(imageHeight))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(24))

      let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
      section.boundarySupplementaryItems = [layoutSectionHeader]

      return section
    }
    return layout
  }
}

extension DetailsViewController: DetailsDisplayLogic {

  func display(viewModel: DetailsScene.ViewModel) {
    Task { @MainActor in
      self.viewModel = viewModel
      let configuration = UserConfiguration(avatar: viewModel.userInfos.avatar,
                                            name: viewModel.userInfos.username,
                                            socialUsername: viewModel.userInfos.socialUsername,
                                            publicationDate: nil)
      userView.frame = navigationItem.titleView?.bounds ?? .zero
      userView.setup(with: configuration)
      navigationItem.titleView = userView

      headerView.setup(with: viewModel.header)

      headerView.setNeedsLayout()
      headerView.layoutIfNeeded()
      headerHeight = HeaderDetailView.size(for: viewModel.header, for: view.bounds.width).height + 16

      collectionView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)

      var snapshot = NSDiffableDataSourceSnapshot<Int, DetailsScene.Picture>()
      snapshot.appendSections([0])
      snapshot.appendItems(viewModel.pictures, toSection: 0)
      await diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
  }

  func display(error: Error) {
    Task { @MainActor in
      let alert = UIAlertController(title: "Information",
                                    message: "erreur",
                                    preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "Fermer", style: .cancel, handler: nil))
      present(alert, animated: true)
    }
  }
}

extension DetailsViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    headerView.updateAlphaDuringScroll(scrollView.contentOffset.y, maxScrollHeight: headerHeight)
  }
}

private extension UIView {

  func updateAlphaDuringScroll(_ verticalScrollPosition: CGFloat, maxScrollHeight: CGFloat) {
    if verticalScrollPosition > 0 {
      alpha = 0
    } else if maxScrollHeight - abs(verticalScrollPosition) > maxScrollHeight * 0.05 {
      alpha = abs(verticalScrollPosition) / maxScrollHeight
    } else {
      alpha = 1
    }
  }
}
