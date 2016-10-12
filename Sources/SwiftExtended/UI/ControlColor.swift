import Foundation
import UIKit

public struct ControlColor {
  public var normal: UIColor
  public var highlighted: UIColor?
  public var selected: UIColor?
  public var disabled: UIColor?
  public var focused: UIColor?
  public var dimmed: UIColor? { return disabled }

  public init(normal: UIColor,
              highlighted: UIColor? = nil,
              selected: UIColor? = nil,
              disabled: UIColor? = nil,
              focused: UIColor? = nil) {
    self.normal = normal
    self.highlighted = highlighted
    self.selected = selected
    self.disabled = disabled
    self.focused = focused
  }
}

public struct ButtonColorConfiguration {
  public var backgroundColor: ControlColor
  public var tintColor: ControlColor

  public init(backgroundColor: ControlColor, tintColor: ControlColor) {
    self.backgroundColor = backgroundColor
    self.tintColor = tintColor
  }

  public static func makeSystem() -> ButtonColorConfiguration {
    return ButtonColorConfiguration(backgroundColor: ControlColor(normal: .white),
                                    tintColor: ControlColor(normal: .blue))
  }
}
