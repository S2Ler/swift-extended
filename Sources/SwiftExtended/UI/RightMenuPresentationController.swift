import UIKit

public final class RightMenuPresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {

  private var chromeView = UIVisualEffectView(effect: nil)

  public override init(presentedViewController: UIViewController,
                       presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController:presentedViewController, presenting:presentingViewController)

    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(chromeViewTapped(gesture:)))
    chromeView.addGestureRecognizer(tapGesture)
  }

  @objc
  private func chromeViewTapped(gesture: UIGestureRecognizer) {
    if gesture.state == .ended {
      presentingViewController.dismiss(animated: true, completion: nil)
    }
  }

  public override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else {
      assertionFailure()
      return .zero
    }

    var presentedViewFrame = CGRect.zero
    let containerBounds = containerView.bounds
    presentedViewFrame.size = size(forChildContentContainer: presentedViewController,
                                   withParentContainerSize: containerBounds.size)
    presentedViewFrame.origin.x = containerBounds.size.width - presentedViewFrame.size.width + 4

    return presentedViewFrame
  }

  public override func size(forChildContentContainer container: UIContentContainer,
                            withParentContainerSize parentSize: CGSize) -> CGSize {
    let width: CGFloat = min(parentSize.width, 271)
    return CGSize(width: width, height: parentSize.height)
  }

  public override func presentationTransitionWillBegin() {
    guard let containerView = self.containerView else {
      assertionFailure()
      return
    }

    chromeView.frame = containerView.bounds
    let changeValues = {
      self.chromeView.effect = UIBlurEffect(style: .dark)
    }
    containerView.insertSubview(chromeView, at:0)
    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { context in
        changeValues()
      }, completion:nil)
    } else {
      changeValues()
    }
  }

  public override func dismissalTransitionWillBegin() {
    let changeValues = {
      self.chromeView.effect = nil
    }

    if let coordinator = presentedViewController.transitionCoordinator {
      coordinator.animate(alongsideTransition: { context in
        changeValues()
        }, completion:nil)
    } else {
      changeValues()
    }
  }

  public override func containerViewWillLayoutSubviews() {
    guard let containerView = self.containerView else {
      assertionFailure()
      return
    }

    chromeView.frame = containerView.bounds
    presentedView?.frame = frameOfPresentedViewInContainerView
  }

  public override var shouldPresentInFullscreen: Bool {
    return true
  }

  public override var adaptivePresentationStyle: UIModalPresentationStyle {
    return .fullScreen
  }
}
