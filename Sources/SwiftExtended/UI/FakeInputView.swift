import Foundation
import UIKit

@objc
public final class FakeInputAccessory: UIView {
  override public var intrinsicContentSize : CGSize {
    return CGSize.zero
  }
  
  deinit {
    superview?.removeObserver(self, forKeyPath: "center")
  }
  
  override public func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    
    superview?.removeObserver(self, forKeyPath: "center")
    newSuperview?.addObserver(self, forKeyPath: "center", options: [.new], context: nil)
  }
  
  override public func observeValue(forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?) {
      guard let object = object as? UIView
        , object == superview && keyPath == "center"
        else { return }
      handler?(self)
  }
  
  public var handler: ((FakeInputAccessory) -> ())?
  public var inOutHandler: ()
}
