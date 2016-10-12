import Foundation
import UIKit

public extension ShadowDefinition {
  func apply(to view: UIView) {
    view.layer.shadowPath = path
    view.layer.shadowColor = color?.cgColor
    view.layer.shadowOffset = offset
    view.layer.shadowRadius = radius
    view.layer.shadowOpacity = opacity
  }
}
