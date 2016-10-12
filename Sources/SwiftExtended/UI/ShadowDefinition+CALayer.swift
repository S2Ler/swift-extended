import Foundation
import QuartzCore

public extension ShadowDefinition {
  func apply(to layer: CALayer) {
    layer.shadowPath = path
    layer.shadowColor = color?.cgColor
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
  }
}
