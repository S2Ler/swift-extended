import UIKit

public extension UITableView {
  func disableHeightEstimations() {
    estimatedRowHeight = 0
    estimatedSectionHeaderHeight = 0
    estimatedSectionFooterHeight = 0
  }
}

