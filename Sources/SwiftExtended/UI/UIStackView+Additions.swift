import UIKit

public extension UIStackView {
  /// Removes all `arrangedSubviews` and add `newViews` instead
  func replaceViews<Views: Sequence>(with newViews: Views) where Views.Iterator.Element: UIView {
    replaceViews(arrangedSubviews, with: newViews)
  }

  /// Removes all `views` and add `newViews` instead
  func replaceViews<Views: Sequence, NewViews: Sequence>(_ views: Views, with newViews: NewViews)
    where Views.Iterator.Element: UIView, NewViews.Iterator.Element: UIView {
    for arrangedView in views {
      removeArrangedSubview(arrangedView)
      arrangedView.removeFromSuperview()
    }

    for newView in newViews {
      addArrangedSubview(newView)
    }
  }
}
