import Foundation
import UIKit

public struct ShadowDefinition {
  public var path: CGPath?
  public var color: UIColor?
  public var offset: CGSize
  public var radius: CGFloat
  public var opacity: Float

  public init(path: CGPath?, color: UIColor?, offset: CGSize, radius: CGFloat, opacity: Float) {
    self.path = path
    self.color = color
    self.offset = offset
    self.radius = radius
    self.opacity = opacity
  }

  public init(from layer: CALayer) {
    path = layer.shadowPath

    if let shadowColor = layer.shadowColor {
      color = UIColor(cgColor: shadowColor)
    } else {
      color = nil
    }

    offset = layer.shadowOffset
    radius = layer.shadowRadius
    opacity = layer.shadowOpacity
  }
}
