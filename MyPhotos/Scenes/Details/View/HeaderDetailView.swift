//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Kingfisher
import UIKit

final class HeaderDetailView: UIView {

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.spacing = 16
    stackView.backgroundColor = .white
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var pictureView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 16
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .natural
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var likeButton: UIButton = {
    let button = UIButton()
    button.setImage(AppAssets.like.image, for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    let action = UIAction(handler: { [weak self] _ in
      guard let self = self else { return }
      self.likeButton.touchAnimation(impactStyle: .medium)
    })
    button.addAction(action, for: .primaryActionTriggered)
    return button
  }()

  private lazy var statsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .leading
    stackView.spacing = 32
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var viewsLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .natural
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var downloadsLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .natural
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInterface()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupInterface()
    setupConstraints()
  }

  static func size(for header: DetailsScene.Header, for width: CGFloat) -> CGSize {
    let view = HeaderDetailView(frame: CGRect(x: 0, y: 0, width: width, height: 200))
    view.setup(with: header)
    view.widthAnchor.constraint(equalToConstant: width).isActive = true
    view.layoutIfNeeded()
    return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
  }

  func setup(with configuration: DetailsScene.Header) {
    descriptionLabel.isHidden = configuration.description.isEmpty
    let processor = RoundCornerImageProcessor(cornerRadius: 16)
    pictureView.kf.setImage(with: configuration.bigPicture,
                            options: [.processor(processor), .transition(ImageTransition.fade(0.5))])
    descriptionLabel.text = configuration.description
    let color: UIColor = configuration.isLiked ? .red : .gray
    likeButton.setImage(AppAssets.like.image.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    let like = configuration.likes > 0 ? "\(configuration.likes)" : ""
    likeButton.setTitle(like, for: .normal)
    viewsLabel.text = "\(configuration.views) views"
    downloadsLabel.text = "\(configuration.downloads) downloads"
  }

  private func setupInterface() {
    statsStackView.addArrangedSubview(viewsLabel)
    statsStackView.addArrangedSubview(downloadsLabel)
    stackView.addArrangedSubview(pictureView)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.addArrangedSubview(likeButton)
    stackView.addArrangedSubview(statsStackView)
    addSubview(stackView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.widthAnchor.constraint(equalTo: widthAnchor),
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

      pictureView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
      pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor)
    ])
  }
}
