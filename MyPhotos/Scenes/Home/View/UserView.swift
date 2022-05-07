//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Kingfisher
import UIKit

struct UserConfiguration {
  let avatar: URL?
  let name: String
  let socialUsername: String
  let publicationDate: String?
}

final class UserView: UIView {

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 12
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var avatarView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()

  private lazy var userInfosStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .boldSystemFont(ofSize: 16.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var socialLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = .systemFont(ofSize: 12)
    label.textColor = .gray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  init() {
    super.init(frame: .zero)
    setupInterface()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupInterface()
    setupConstraints()
  }

  func setup(with configuration: UserConfiguration) {
    nameLabel.text = configuration.name
    socialLabel.text = configuration.socialUsername

    let processor = RoundCornerImageProcessor(cornerRadius: 48)
    avatarView.kf.setImage(with: configuration.avatar,
                            options: [.processor(processor), .transition(ImageTransition.fade(0.5))])
  }

  private func setupInterface() {
    userInfosStackView.addArrangedSubview(nameLabel)
    userInfosStackView.addArrangedSubview(socialLabel)
    stackView.addArrangedSubview(avatarView)
    stackView.addArrangedSubview(userInfosStackView)
    stackView.addArrangedSubview(dateLabel)
    addSubview(stackView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

      avatarView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
      avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor)
    ])
  }
}
