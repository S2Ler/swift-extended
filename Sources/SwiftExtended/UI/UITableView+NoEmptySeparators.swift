import Foundation
import UIKit

public extension UITableView {
  /// Sets empty tableFooterView which removes empty rows separators
  func removeEmptyBottomSeparators() {
    self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
  }
}
