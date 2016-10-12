import Foundation

public extension DSLButtonAnyStateHandler {
  static func makeShadowHighlight(shadowDefinition: ShadowDefinition,
                                         normalShadowDefinition: ShadowDefinition) -> DSLButtonAnyStateHandler {
    return DSLButtonAnyStateHandler(onStateChanged: { (button) in
      if button.isHighlighted {
        shadowDefinition.apply(to: button)
      } else {
        normalShadowDefinition.apply(to: button)
      }
    })
  }
}
