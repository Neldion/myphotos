//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Kingfisher
import UIKit

protocol PostCellDelegate: AnyObject {
  func didTapLike(in cell: PostCell)
}

final class PostCell: UICollectionViewCell {

  private weak var delegate: PostCellDelegate?

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    stackView.layoutMargins = UIEdgeInsets(top: 16,
                                       left: 12,
                                           bottom: 16,
                                       right: 12)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.backgroundColor = .white
    stackView.layer.cornerRadius = 16
    stackView.clipsToBounds = false
    stackView.layer.shadowColor = UIColor.gray.cgColor
    stackView.layer.shadowOpacity = 0.8
    stackView.layer.shadowOffset = CGSize(width: 1, height: 3)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var userView: UserView = {
    let view = UserView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
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
      self.delegate?.didTapLike(in: self)
    })
    button.addAction(action, for: .primaryActionTriggered)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupInterface()
    setupConstraints()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    setupInterface()
    setupConstraints()
  }

  static func size(for post: HomeScene.Post, for width: CGFloat) -> CGSize {
    let cell = PostCell(frame: CGRect(x: 0, y: 0, width: width, height: 200))
    cell.setup(with: post)
    cell.stackView.widthAnchor.constraint(equalToConstant: width).isActive = true
    cell.layoutIfNeeded()
    return cell.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
  }

  func setup(with post: HomeScene.Post, delegate: PostCellDelegate? = nil) {
    self.delegate = delegate
    descriptionLabel.isHidden = post.descriptionPost.isEmpty
    let userConfiguration = UserConfiguration(avatar: post.avatar,
                                 name: post.username,
                                 socialUsername: post.socialUsername,
                                 publicationDate: post.publicationDate)
    userView.setup(with: userConfiguration)
    let processor = RoundCornerImageProcessor(cornerRadius: 16)
    pictureView.kf.setImage(with: post.picture,
                            options: [.processor(processor), .transition(ImageTransition.fade(0.5))])
    descriptionLabel.text = post.descriptionPost
    let color: UIColor = post.isLiked ? .red : .gray
    likeButton.setImage(AppAssets.like.image.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    let like = post.likes > 0 ? "\(post.likes)" : ""
    likeButton.setTitle(like, for: .normal)
  }

  private func setupInterface() {
    stackView.addArrangedSubview(userView)
    stackView.setCustomSpacing(12, after: userView)
    stackView.addArrangedSubview(pictureView)
    stackView.setCustomSpacing(16, after: pictureView)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.setCustomSpacing(16, after: descriptionLabel)
    stackView.addArrangedSubview(likeButton)
    contentView.addSubview(stackView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.widthAnchor.constraint(equalToConstant: contentView.bounds.size.width),
      stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      pictureView.widthAnchor.constraint(equalToConstant: contentView.bounds.size.width - 24),
      pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor),

      userView.heightAnchor.constraint(equalToConstant: 48)
    ])
  }
}
