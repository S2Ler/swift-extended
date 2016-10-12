import UIKit

@objc
public final class SlideAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

  public enum Direction {
    case fromLeft
    case fromRight
    case fromTop
    case fromBottom
  }

  private let isPresentation: Bool
  private let slideDirection: Direction
  private let animationDuration: TimeInterval
  private let animator: UIViewPropertyAnimator?

  internal init(isPresentation: Bool,
                slideDirection: Direction,
                animationDuration: TimeInterval = 0.25,
                animator: UIViewPropertyAnimator?) {
    self.isPresentation = isPresentation
    self.slideDirection = slideDirection
    self.animationDuration = animationDuration
    self.animator = animator
  }

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let fromView: UIView = fromVC.view
    let toView: UIView = toVC.view
    let containerView = transitionContext.containerView

    if isPresentation {
      containerView.addSubview(toView)
    }

    let animatingVC = isPresentation ? toVC : fromVC
    let animatingView = animatingVC.view

    let finalFrameForVC = transitionContext.finalFrame(for: animatingVC)
    var initialFrameForVC = finalFrameForVC
    switch slideDirection {
    case .fromRight:
      initialFrameForVC.origin.x = containerView.bounds.maxX
    case .fromLeft:
      initialFrameForVC.origin.x = -finalFrameForVC.width
    case .fromTop:
      initialFrameForVC.origin.y = -finalFrameForVC.height
    case .fromBottom:
      initialFrameForVC.origin.y = containerView.bounds.maxY
    }

    let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
    let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC

    animatingView?.frame = initialFrame

    let animator = self.animator
      ?? UIViewPropertyAnimator(duration: animationDuration, curve: UIView.AnimationCurve.easeInOut, animations: nil)
    animator.addAnimations {
      animatingView?.frame = finalFrame
    }

    animator.addCompletion { _ in
      if !self.isPresentation {
        fromView.removeFromSuperview()
      }
      transitionContext.completeTransition(true)
    }
    animator.startAnimation()
  }
}
