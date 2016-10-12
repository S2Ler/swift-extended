import Foundation
import UIKit

public struct GradientComponent {
  public var red: CGFloat
  public var green: CGFloat
  public var blue: CGFloat
  public var alpha: CGFloat
  public var location: CGFloat

  public init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat, location: CGFloat) {
    red = r / 255.0
    green = g / 255.0
    blue = b / 255.0
    alpha = a / 255.0
    self.location = location
  }

  public init(color: UIColor, location: CGFloat) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    self.location = location
  }

  public var color: UIColor {
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
}

public struct GradientDefinition {
  public var components: [GradientComponent]
  public var startPoint: CGPoint
  public var endPoint: CGPoint

  public init(components: [GradientComponent], startPoint: CGPoint, endPoint: CGPoint) {
    self.components = components
    self.startPoint = startPoint
    self.endPoint = endPoint
  }
}

public extension CGGradient {
  static func make(with components: [GradientComponent]) -> CGGradient? {
    let colorSpace = CGColorSpaceCreateDeviceRGB()

    var cgComponents: [CGFloat] = []

    for component in components {
      cgComponents.append(component.red)
      cgComponents.append(component.green)
      cgComponents.append(component.blue)
      cgComponents.append(component.alpha)
    }

    var locations: [CGFloat] = []

    for component in components {
      locations.append(component.location)
    }

    let gradient = CGGradient(colorSpace: colorSpace,
                              colorComponents: cgComponents,
                              locations: locations,
                              count: components.count)

    return gradient
  }

  static func make(startColor: UIColor, endColor: UIColor) -> CGGradient? {
    let startComponent = GradientComponent(color: startColor, location: 0)
    let endComponent = GradientComponent(color: endColor, location: 1)

    return make(with: [startComponent, endComponent])
  }
}

public extension CAGradientLayer {
  static func make(from definition: GradientDefinition) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.update(from: definition)
    return gradientLayer
  }

  func update(from definition: GradientDefinition) {
    colors = definition.components.map { $0.color.cgColor }
    locations = definition.components.map { NSNumber(value: Double($0.location)) }
    startPoint = definition.startPoint
    endPoint = definition.endPoint
  }
}
