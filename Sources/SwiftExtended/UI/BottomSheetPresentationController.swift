import Foundation
import UIKit

/// - note: `preferredContentSize` is required for presentedViewController
public final class BottomSheetPresentationController: UIPresentationController {
  private var hapticEngine: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
  private let cancelButtonTitle: String

  private let dimmingView: UIVisualEffectView = {
    let view = UIVisualEffectView(effect: nil)
    return view
  }()

  private lazy var cancelButton: UIButton! = {
    let button = UIButton(type: UIButton.ButtonType.custom)
    button.backgroundColor = UIColor.black
    button.setAttributedTitle(NSAttributedString(string: self.cancelButtonTitle,
                                                 attributes: [
                                                  .font: UIFont.systemFont(ofSize: 20,
                                                                           weight: .semibold),
                                                  .kern: 0.4,
                                                  .foregroundColor: UIColor.white,
                                                  ]), for: .normal)
    button.setAttributedTitle(NSAttributedString(string: self.cancelButtonTitle,
                                                 attributes: [
                                                  .font: UIFont.systemFont(ofSize: 20,
                                                                           weight: .semibold),
                                                  .kern: 0.4,
                                                  .foregroundColor: UIColor.white.withAlphaComponent(0.8),
                                                  ]), for: .highlighted)

    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    return button
  }()

  public init(presentedViewController: UIViewController,
              presenting presentingViewController: UIViewController?,
              cancelButtonTitle: String = NSLocalizedString("Cancel", comment: "")) {
    self.cancelButtonTitle = cancelButtonTitle
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

    let hideGesture = UITapGestureRecognizer(target: self, action: #selector(onHideGesture))
    dimmingView.contentView.addGestureRecognizer(hideGesture)

    cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)

    hapticEngine?.prepare()
  }

  @objc
  private func onHideGesture(_ gesture: UIGestureRecognizer) {
    if gesture.state == .ended {
      hidePresentedViewController()
    }
  }

  @objc
  private func onCancel(_ sender: Any?) {
    hidePresentedViewController()
  }

  private func hidePresentedViewController() {
    presentedViewController.dismiss(animated: true, completion: nil)
  }

  public override func presentationTransitionWillBegin() {
    guard let containerView = self.containerView else {
      preconditionFailure("Why containerView is nil here")
    }

    presentedViewController.view.layer.cornerRadius = 12
    presentedViewController.view.layer.masksToBounds = true
    dimmingView.frame = containerView.bounds

    containerView.insertSubview(dimmingView, at: 0)
    dimmingView.contentView.addSubview(cancelButton)

    cancelButton.frame = frameOfCancelButton
    cancelButton.transform = CGAffineTransform(translationX: 0, y: 300)

    let applyChanges: () -> Void = {
      self.dimmingView.effect = UIBlurEffect(style: .dark)
      self.cancelButton.transform = .identity
    }

    if let transitionCoordinator = presentedViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: { (context) in
        applyChanges()
        self.hapticEngine?.impactOccurred()
        self.hapticEngine = nil
      }, completion: nil)
    } else {
      applyChanges()
    }
  }

  public override func presentationTransitionDidEnd(_ completed: Bool) {
    if !completed {
      dimmingView.removeFromSuperview()
      cancelButton.removeFromSuperview()
    }
  }

  public override func dismissalTransitionWillBegin() {
    let applyChanges: () -> Void = {
      self.dimmingView.effect = nil
      self.cancelButton.transform = CGAffineTransform(translationX: 0, y: 200)
    }

    if let transitionCoordinator = presentedViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: { (context) in
        applyChanges()
      }, completion: nil)
    } else {
      applyChanges()
    }
  }

  public override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
      dimmingView.removeFromSuperview()
      cancelButton.removeFromSuperview()
    }
  }

  public override func containerViewDidLayoutSubviews() {
    self.dimmingView.frame = containerView!.bounds
    self.cancelButton.frame = frameOfCancelButton
  }

  let margin = CGFloat(9)

  public override var frameOfPresentedViewInContainerView: CGRect {
    guard let containerView = self.containerView else { return .zero }

    let containerViewBounds = containerView.bounds
    let frameOfCancelButton = self.frameOfCancelButton
    let preferredHeight = min(presentedViewController.preferredContentSize.height,
                              containerViewBounds.height - frameOfCancelButton.height - margin * 3 - 20)
    let presentedViewFrame = CGRect(x: margin,
                                    y: frameOfCancelButton.minY - preferredHeight - margin,
                                    width: containerViewBounds.width - margin * 2,
                                    height: preferredHeight)
    return presentedViewFrame
  }

  private var frameOfCancelButton: CGRect {
    guard let containerView = self.containerView else { return .zero }
    let containerViewBounds = containerView.bounds
    let buttonHeight = CGFloat(57)

    return CGRect(x: margin,
                  y: containerViewBounds.maxY - buttonHeight - margin,
                  width: containerViewBounds.width - margin * 2,
                  height: buttonHeight)
  }

  public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }

  public override var shouldRemovePresentersView: Bool {
    return false
  }
}
