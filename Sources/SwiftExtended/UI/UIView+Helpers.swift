import UIKit

public extension UIView {
  final func removeSubviews() {
    subviews.forEach { $0.removeFromSuperview() }
  }
}
