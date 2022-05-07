//
//  Copyright (c) 2022 MyPhotos. All rights reserved.
//

import Foundation

public extension Array {
  subscript(safe index: Int) -> Element? {
    return self.indices ~= index ? self[index] : nil
  }
}
