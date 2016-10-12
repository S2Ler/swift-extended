import Foundation

public extension DSLButtonAnyStateHandler {

  /// Returns state handler which overrides button tint color based on highlightState
  static func makeForColorConfiguration(_ configuration: ButtonColorConfiguration) -> DSLButtonAnyStateHandler {

    return DSLButtonAnyStateHandler(onStateChanged: { (button) in
      if button.tintAdjustmentMode == .dimmed {
        button.tintColor = configuration.tintColor.dimmed
        button.backgroundColor = configuration.backgroundColor.dimmed
      } else  if button.isHighlighted {
        button.tintColor = configuration.tintColor.highlighted
        button.backgroundColor = configuration.backgroundColor.highlighted
      } else if button.isSelected {
        button.tintColor = configuration.tintColor.selected
        button.backgroundColor = configuration.backgroundColor.selected
      } else if !button.isEnabled {
        button.tintColor = configuration.tintColor.disabled
        button.backgroundColor = configuration.backgroundColor.disabled
      } else if button.isFocused {
        button.tintColor = configuration.tintColor.focused
        button.backgroundColor = configuration.backgroundColor.focused
      } else {
        button.tintColor = configuration.tintColor.normal
        button.backgroundColor = configuration.backgroundColor.normal
      }
    })
  }
}
