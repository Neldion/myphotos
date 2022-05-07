//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Kingfisher
import UIKit

final class PictureCell: UICollectionViewCell {

  private lazy var pictureView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 16
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView  }()

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

  func setup(picture: URL?) {
    let processor = RoundCornerImageProcessor(cornerRadius: 16)
    pictureView.kf.setImage(with: picture,
                            options: [.processor(processor), .transition(ImageTransition.fade(0.5))])
  }

  private func setupInterface() {
    contentView.addSubview(pictureView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
      pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
}
