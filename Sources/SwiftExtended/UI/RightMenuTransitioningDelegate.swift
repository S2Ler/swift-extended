import UIKit

public final class RightMenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

  @objc public func presentationController(forPresented presented: UIViewController,
                                           presenting: UIViewController?,
                                           source: UIViewController) -> UIPresentationController? {
    let presentationController = RightMenuPresentationController(presentedViewController:presented,
                                                                 presenting:presenting)

    return presentationController
  }

  public func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animationController = SlideAnimatedTransitioning(isPresentation: true,
                                                         slideDirection: .fromRight,
                                                         animator: nil)
    return animationController
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animationController = SlideAnimatedTransitioning(isPresentation: false,
                                                         slideDirection: .fromRight,
                                                         animator: nil)
    return animationController
  }

}
