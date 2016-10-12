import Foundation
import UIKit

public extension UINavigationController {
  func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
    pushViewController(viewController, animated: animated)
    callCompletionOnAnimationEnd(animatedTransition: animated, completion: completion)
  }
  
  func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
    popToViewController(viewController, animated: animated)
    callCompletionOnAnimationEnd(animatedTransition: animated, completion: completion)
  }
  
  func popViewController(animated: Bool, completion: @escaping () -> Void) {
    self.popViewController(animated: animated)
    callCompletionOnAnimationEnd(animatedTransition: animated, completion: completion)
  }
  
  fileprivate func callCompletionOnAnimationEnd(animatedTransition animated: Bool, completion: @escaping () -> Void) {
    guard animated, let coordinator = transitionCoordinator else {
      completion()
      return
    }
    
    coordinator.animate(alongsideTransition: nil) { _ in completion() }
  }
}
