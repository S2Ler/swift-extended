import Foundation
import UIKit

///  Allows to create view controllers from storyboards in type-save manner
public protocol LoadableFromStoryboard: class {
  static var storyboardName: String { get }
  static var storyboardID: String { get }
  static var storyboardBundle: Bundle? { get }
}

public extension LoadableFromStoryboard {
  static var storyboardBundle: Bundle? {
    return Bundle(for: self)
  }

  static var storyboardID: String {
    return String(describing: self)
  }

  static var storyboardName: String {
    return String(describing: self)
  }
}

public extension LoadableFromStoryboard where Self: UIViewController  {
  static func makeFromStoryboard() -> Self {
    let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
    return storyboard.instantiateViewController(withIdentifier: Self.storyboardID) as! Self
  }
}
