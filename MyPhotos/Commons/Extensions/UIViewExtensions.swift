//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import UIKit

extension UIView {
  public func touchAnimation(animationLength: TimeInterval = 0.3,
                             dampingRatio: CGFloat = 0.5,
                             scale: CGFloat = 0.95,
                             impactStyle: UIImpactFeedbackGenerator.FeedbackStyle? = nil) {
    let scaleTransform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)

    let propertyAnimator = UIViewPropertyAnimator(duration: animationLength, dampingRatio: dampingRatio) {
      if let style = impactStyle {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.prepare()
        impact.impactOccurred()
      }
      self.transform = scaleTransform
    }

    propertyAnimator.addAnimations({ self.transform = .identity }, delayFactor: CGFloat(animationLength))
    propertyAnimator.startAnimation()
  }
}
