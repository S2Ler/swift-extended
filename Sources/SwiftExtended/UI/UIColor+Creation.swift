import UIKit

// TODO: Add support for wide colors

public extension UIColor {
  func shadowing(_ shadow: CGFloat) -> UIColor {
    var red: CGFloat = 1.0, green: CGFloat = 1.0, blue: CGFloat = 1.0, alpha: CGFloat = 1.0
    self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return UIColor(red: red * (1-shadow),
                   green: green * (1-shadow),
                   blue: blue * (1-shadow),
                   alpha: alpha * (1-shadow) + shadow)
  }

  func blendedColorWithFraction(_ fraction: CGFloat, ofColor color: UIColor) -> UIColor {
    var r1: CGFloat = 1.0, g1: CGFloat = 1.0, b1: CGFloat = 1.0, a1: CGFloat = 1.0
    var r2: CGFloat = 1.0, g2: CGFloat = 1.0, b2: CGFloat = 1.0, a2: CGFloat = 1.0

    self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

    return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
                   green: g1 * (1 - fraction) + g2 * fraction,
                   blue: b1 * (1 - fraction) + b2 * fraction,
                   alpha: a1 * (1 - fraction) + a2 * fraction)
  }

  /// Create color from 8 bit per components representation
  ///
  /// - parameter red: red component (0-255)
  /// - parameter green: green component (0-255)
  /// - parameter blue: blue component (0-255)
  /// - parameter alpha: alpha component (0-255)
  convenience init(_ red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8 = 255) {
    let delimeter: CGFloat = 255.0
    self.init(red: CGFloat(red)/delimeter,
              green: CGFloat(green)/delimeter,
              blue: CGFloat(blue)/delimeter,
              alpha: CGFloat(alpha)/delimeter)
  }

  /// Create color from 8 bit per components representation
  ///
  /// - parameter white: white component (0-255)
  /// - parameter alpha: alpha component (0-255)
  convenience init(_ white: UInt8, _ alpha: UInt8 = 255) {
    let delimeter: CGFloat = 255.0
    self.init(white: CGFloat(white)/delimeter, alpha: CGFloat(alpha)/delimeter)
  }

  /// Extracts Red Green Blue Alpha components from color.
  /// - returns: Returns nil if for some reason components cannot be extracted
  func rgba() -> (Int, Int, Int, Int)? {
    var fRed: CGFloat = 0
    var fGreen: CGFloat = 0
    var fBlue: CGFloat = 0
    var fAlpha: CGFloat = 0
    if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
      let iRed = Int(fRed * 255.0)
      let iGreen = Int(fGreen * 255.0)
      let iBlue = Int(fBlue * 255.0)
      let iAlpha = Int(fAlpha * 255.0)

      return (iRed, iGreen, iBlue, iAlpha)
    } else {
      // Could not extract RGBA components:
      return nil
    }
  }
}
