import UIKit

open class DSLBarButtonItem: UIBarButtonItem {

  /// A block to call when item is activated. 
  /// - important: this method overrides `target` and `action` properties
  public final var actionBlock: (() -> ())? {
    didSet {
      actionBlockUpdated()
    }
  }

  public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, actionBlock: (() -> Void)?) {
    self.init()
    self.image = image
    self.landscapeImagePhone = landscapeImagePhone
    self.style = style
    self.actionBlock = actionBlock
    actionBlockUpdated()
  }

  public convenience init(title: String?, style: UIBarButtonItem.Style, actionBlock: (() -> Void)?) {
    self.init()
    self.title = title
    self.style = style
    self.actionBlock = actionBlock
    actionBlockUpdated()
  }

  public convenience init(image: UIImage?, style: UIBarButtonItem.Style, actionBlock: (() -> Void)?) {
    self.init()
    self.image = image
    self.style = style
    self.actionBlock = actionBlock
    actionBlockUpdated()
  }

  @objc
  public func callActionBlock() {
    actionBlock?()
  }

  private func actionBlockUpdated() {
    if actionBlock != nil {
      self.target = self
      self.action = #selector(callActionBlock)
    } else {
      self.target = nil
      self.action = nil
    }
  }
}
