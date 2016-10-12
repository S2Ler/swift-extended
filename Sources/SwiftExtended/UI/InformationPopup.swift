import Foundation
import UIKit

public final class InformationPopupController: UIViewController {
  // MARK: - Setup

  public var dismissOnTappingOutside: Bool = false
  public var autoDismissOnPressingButton: Bool = true

  // MARK - Init

  public init() {
    super.init(nibName: nil, bundle: nil)
    postInit()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate func postInit() {
    transitioningDelegate = self
    modalPresentationStyle = .custom
  }

  // MARK: - UIViewController

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white
    view.layer.masksToBounds = true

    if let contentViewController = contentViewController , contentViewController.parent == nil {
      placeNewContentViewController(contentViewController)
    }

    placeButtons()
  }

  public override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }

  override public func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    super.preferredContentSizeDidChange(forChildContentContainer: container)
    updatePreferredContentSize()
  }

  public var contentViewController: UIViewController? {
    didSet {
      if let oldContentViewController = oldValue {
        oldContentViewController.willMove(toParent: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.removeFromParent()
      }

      if let newContentViewController = contentViewController , isViewLoaded {
        placeNewContentViewController(newContentViewController)
      }
    }
  }

  private func placeNewContentViewController(_ viewController: UIViewController) {
    addChild(viewController)

    let contentView: UIView = viewController.view
    let views = ["content": contentView]
    contentView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(contentView)
    var contentViewBounds = view.bounds
    contentViewBounds.size.height -= buttonsHeight

    contentView.frame = contentViewBounds

    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]-(buttonHeight@1000)-|",
                                                       options: [],
                                                       metrics: ["buttonHeight": buttonsHeight],
                                                       views: views))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[content]|",
                                                       options: [],
                                                       metrics: nil,
                                                       views: views))
    
    viewController.didMove(toParent: self)
    
    updatePreferredContentSize()
  }

  private func updatePreferredContentSize() {
    guard let newContentViewController = contentViewController else { return }

    var newContentSize = newContentViewController.preferredContentSize
    newContentSize.height += buttonsHeight
    preferredContentSize = newContentSize
  }

  // MARK: - Buttons

  public var buttons: [UIButton]? {
    didSet {
      oldValue?.forEach { $0.removeFromSuperview() }

      guard isViewLoaded else { return }
      placeButtons()
    }
  }

  fileprivate func placeButtons() {
    guard let buttons = buttons else { return }
    setNewButtons(buttons)
  }

  fileprivate var buttonsHeight: CGFloat {
    if buttons == nil {
      return 0
    } else {
      return 50
    }
  }

  @objc
  private func onButtonTap(_ button: UIButton) {
    if autoDismissOnPressingButton {
      dismiss(animated: true, completion: nil)
    }
  }

  private func setNewButtons(_ buttons: [UIButton]) {
    for button in buttons {
      button.removeTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
      button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)

      button.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(button)

      button.addConstraint(NSLayoutConstraint(item: button,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: buttonsHeight))
      view.addConstraint(NSLayoutConstraint(item: button,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: 0))
    }

    if let lastButton = buttons.last {
      view.addConstraint(NSLayoutConstraint(item: lastButton,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: 0))
    }

    var previousView = view
    for button in buttons {
      view.addConstraint(NSLayoutConstraint(item: button,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: previousView,
                                            attribute: .left,
                                            multiplier: 1,
                                            constant: 0))

      if previousView != view {
        view.addConstraint(NSLayoutConstraint(item: button,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: previousView,
                                              attribute: .width,
                                              multiplier: 1,
                                              constant: 0))
      }

      previousView = button
    }
  }
}

// MARK: - Impl UIViewControllerTransitioningDelegate

extension InformationPopupController: UIViewControllerTransitioningDelegate {
  public func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController) -> UIPresentationController?
  {
    let presentationController = PresentationController(presentedViewController: presented,
      presenting: source)
    let tapRecognizer = UITapGestureRecognizer(target: self,
                                               action: #selector(InformationPopupController.dimmingViewTapped(_:)))
    presentationController.dimmingView.addGestureRecognizer(tapRecognizer)
    
    return presentationController;
  }
  
  public func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController) -> UIViewControllerAnimatedTransitioning?
  {
    return TransitionPresentationAnimator()
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return TransitionDismissAnimator()
  }
  
  @objc
  fileprivate func dimmingViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
    if dismissOnTappingOutside {
      dismiss(animated: true, completion: nil)
    }
  }
}

// MARK: - UIPresentationController

extension InformationPopupController {
  class PresentationController: UIPresentationController {
    
    let dimmingView: UIVisualEffectView
    
    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
      dimmingView = PresentationController.createDimmingView()
      
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    static func createDimmingView() -> UIVisualEffectView {
      let visualEffectView = UIVisualEffectView(effect: nil)
      return visualEffectView
    }
    
    override func presentationTransitionWillBegin() {
      if let containerView = self.containerView {
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
      }

      if let coordinator = presentedViewController.transitionCoordinator {
        coordinator.animate(alongsideTransition: { (context) in
          self.dimmingView.effect = UIBlurEffect(style: .dark)
        }, completion: nil)
      }
      else {
        dimmingView.effect = UIBlurEffect(style: .dark)
      }
    }
    
    override func dismissalTransitionWillBegin() {
      if let coordinator = presentedViewController.transitionCoordinator {
        coordinator.animate(alongsideTransition: { (context) in
          self.dimmingView.effect = nil
        }, completion: nil)
      }
      else {
        dimmingView.effect = nil
      }
    }
    
    override func containerViewWillLayoutSubviews() {
      if let containerView = self.containerView {
        dimmingView.frame = containerView.bounds
      }
      
      if let presentedView = self.presentedView {
        presentedView.frame = frameOfPresentedViewInContainerView
      }
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
      withParentContainerSize parentSize: CGSize) -> CGSize
    {
      let preferredContentSize = container.preferredContentSize
      var actualContentSize = CGSize()
      actualContentSize.width = min(parentSize.width - 20, preferredContentSize.width)
      actualContentSize.height = min(parentSize.height - 100, preferredContentSize.height)
      
      return actualContentSize
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {

      guard let containerView = self.containerView else { return CGRect.zero }
      
      let containerBounds = containerView.bounds
      let contentContainer = presentedViewController
      var presentedViewFrame = CGRect.zero
      let contentSize = size(forChildContentContainer: contentContainer,
        withParentContainerSize: containerBounds.size)
      presentedViewFrame.size = contentSize
      presentedViewFrame.origin.x = floor(containerBounds.midX - contentSize.width / 2.0)
      presentedViewFrame.origin.y = floor(containerBounds.midY - contentSize.height / 2.0)
      
      return presentedViewFrame
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
      if let presentedView = self.presentedView {
        presentedView.frame = frameOfPresentedViewInContainerView
      }
    }
  }
  
  class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else { return }
      let containerView = transitionContext.containerView
      
      let animationDuration = transitionDuration(using: transitionContext)
      toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
      toViewController.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      toViewController.view.layer.shadowColor = UIColor.black.cgColor
      toViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
      toViewController.view.layer.shadowOpacity = 0.3
      toViewController.view.layer.cornerRadius = 12.0
      toViewController.view.clipsToBounds = true
      
      containerView.addSubview(toViewController.view)
    
      UIView.animate(withDuration: animationDuration,
                                 delay: 0,
                                 usingSpringWithDamping: 0.7,
                                 initialSpringVelocity: 1,
                                 options: UIView.AnimationOptions(rawValue: 0),
                                 animations: {
                                  toViewController.view.transform = CGAffineTransform.identity
        },
                                 completion: { finished in
                                  transitionContext.completeTransition(finished)
      })
    }
  }
  
  class TransitionDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
      
      let animationDuration = transitionDuration(using: transitionContext)
      
      UIView.animate(withDuration: animationDuration,
                                 delay: 0,
                                 options: UIView.AnimationOptions.curveEaseIn,
                                 animations: { 
                                  fromViewController.view.alpha = 0.0
                                  fromViewController.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      }) { finished in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)        
      }
    }
  }
}
