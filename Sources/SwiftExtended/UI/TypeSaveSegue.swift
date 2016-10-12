import Foundation
import UIKit

public protocol StoryboardSegueId: RawRepresentable where RawValue == String {

}

public extension UIStoryboardSegue {
  func unwrapSegueID<SegueID: StoryboardSegueId>() -> SegueID {
    guard let segueIdentifier = identifier,
      let segueID = SegueID(rawValue: segueIdentifier) else {
        preconditionFailure("Wrong segue id")
    }
    
    return segueID
  }

  func unwrapDestinationViewController<ViewController>() -> ViewController {
    guard let viewController = destination as? ViewController else {
      preconditionFailure("Failed to unwrap to \(ViewController.self)")
    }
    return viewController
  }
}

public extension UIViewController {
  func performSegue<SegueId: StoryboardSegueId>(_ id: SegueId, sender: Any? = nil) {
    performSegue(withIdentifier: id.rawValue, sender: sender)
  }
}
