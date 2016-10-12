import Foundation
import UIKit

/// - important: use only from main thread
open class DSLButton: UIButton {
  // - MARK: State monitoring

  private var stateHandlers: [DSLButtonStateHandler] = []

  public func addStateHandler(_ handler: DSLButtonStateHandler) {
    stateHandlers.append(handler)
  }

  open override var isHighlighted: Bool {
    didSet {
      onStateChanged()
    }
  }

  open override var isSelected: Bool {
    didSet {
      onStateChanged()
    }
  }

  open override var isEnabled: Bool {
    didSet {
      onStateChanged()
    }
  }

  open override func tintColorDidChange() {
    super.tintColorDidChange()
    onStateChanged()
  }

  private func onStateChanged() {
    stateHandlers.forEach {
      $0.stateChanged(button: self)
    }
  }

  open override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    if newWindow != nil {
      onStateChanged() // make sure state handlers can update button
    }
  }

  // MARK: - Action Blocks

  private var actionBlocksInitialized: Bool = false

  private var actionBlocks: [(DSLButton) -> Void] = [] {
    didSet {
      if actionBlocks.count > 0 && !actionBlocksInitialized {
        actionBlocksInitialized = true
        addTarget(self, action: #selector(onTapInside), for: .touchUpInside)
      }
    }
  }

  @objc
  private func onTapInside() {
    actionBlocks.forEach {
      $0(self)
    }
  }

  public func addActionBlock(_ actionBlock: @escaping (DSLButton) -> Void) {
    actionBlocks.append(actionBlock)
  }

  // MARK: - Extended Touch Area

  @IBInspectable public var extendedTouchArea: CGPoint = .zero

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    guard extendedTouchArea != .zero else {
      return super.point(inside: point, with: event)
    }

    let touchArea = bounds.insetBy(dx: -extendedTouchArea.x, dy: -extendedTouchArea.y)
    return touchArea.contains(point)
  }

  open override var intrinsicContentSize: CGSize {
    if let customIntrinsicContentSize = self.customIntrinsicContentSize?(self) {
      return customIntrinsicContentSize
    } else {
      return super.intrinsicContentSize
    }
  }

  public var customIntrinsicContentSize: ((DSLButton) -> CGSize?)? {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
}

public protocol DSLButtonStateHandler {
  func stateChanged(button: DSLButton)
}

public struct DSLButtonAnyStateHandler: DSLButtonStateHandler {
  private let onStateChanged: (DSLButton) -> Void

  public init(onStateChanged: @escaping (DSLButton) -> Void) {
    self.onStateChanged = onStateChanged
  }

  public func stateChanged(button: DSLButton) {
    onStateChanged(button)
  }
}
