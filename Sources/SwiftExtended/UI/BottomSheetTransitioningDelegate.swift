import Foundation
import UIKit

public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  private let cancelButtonTitle: String

  public init(cancelButtonTitle: String) {
    self.cancelButtonTitle = cancelButtonTitle
  }

  @objc public func presentationController(forPresented presented: UIViewController,
                                           presenting: UIViewController?,
                                           source: UIViewController) -> UIPresentationController? {
    let presentationController = BottomSheetPresentationController(presentedViewController:presented,
                                                                   presenting:presenting,
                                                                   cancelButtonTitle: cancelButtonTitle)

    return presentationController
  }

  public func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: nil)
    let animationController = SlideAnimatedTransitioning(isPresentation: true,
                                                         slideDirection: .fromBottom,
                                                         animationDuration: 0.5,
                                                         animator: animator)
    return animationController
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: nil)

    let animationController = SlideAnimatedTransitioning(isPresentation: false,
                                                         slideDirection: .fromBottom,
                                                         animationDuration: 0.25,
                                                         animator: animator)
    return animationController
  }
}
