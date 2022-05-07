//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .natural
    label.textColor = .black
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

  func setup(with title: String) {
    titleLabel.text = title
    titleLabel.font = .boldSystemFont(ofSize: 18)
  }

  private func setupInterface() {
    addSubview(titleLabel)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
}
