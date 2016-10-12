import Foundation
import UIKit

//MARK: - CGRect
public struct CGRectTransform {
  public let x: CGFloat?
  public let y: CGFloat?
  public let width: CGFloat?
  public let height: CGFloat?
  
  public init(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat?) {
    self.x = x; self.y = y; self.width = width; self.height = height
  }
  
  public init(_ insets: UIEdgeInsets) {
    self.init(
      x: insets.left,
      y:insets.top,
      width:-insets.left - insets.right,
      height: -insets.top - insets.bottom
    )
  }
}

public extension CGRect {
  func transform(_ transform: CGRectTransform) -> CGRect {
    var transformed = self
    if let x = transform.x {
      transformed.origin.x += x
    }
    
    if let y = transform.y {
      transformed.origin.y += y
    }
    
    if let width = transform.width {
      transformed.size.width += width
    }
    
    if let height = transform.height {
      transformed.size.height += height
    }
    
    return transformed
  }
}

public extension CGRect {
  func applyEdgeInsets(_ insets: UIEdgeInsets) -> CGRect {
    return transform(CGRectTransform(insets))
  }
}

//MARK: - CGPoint
public struct CGPointTransform {
  public let x: CGFloat?
  public let y: CGFloat?
  
  public init(y: CGFloat) {
    self.x = nil
    self.y = y
  }
  
  public init(x: CGFloat, y: CGFloat? = nil) {
    self.x = x
    self.y = y
  }
}

public extension CGPoint {
  func transform(_ transform: CGPointTransform) -> CGPoint {
    var transformed = self
    if let x = transform.x {
      transformed.x += x
    }
    
    if let y = transform.y {
      transformed.y += y
    }
        
    return transformed
  }
  
  func changeWithTransform(_ changeTransform: CGPointTransform) -> CGPoint {
    var transformed = self
    if let x = changeTransform.x {
      transformed.x = x
    }
    
    if let y = changeTransform.y {
      transformed.y = y
    }
    
    return transformed
  }
}

//MARK: - CGSize

public struct CGSizeTransform {
  public let width: CGFloat?
  public let height: CGFloat?
  
  public init(height: CGFloat) {
    self.width = nil
    self.height = height
  }
  
  public init(width: CGFloat, height: CGFloat? = nil) {
    self.width = width
    self.height = height
  }
}

public extension CGSize {
  func transform(_ transform: CGSizeTransform) -> CGSize {
    var transformed = self
    if let width = transform.width {
      transformed.width += width
    }
    
    if let height = transform.height {
      transformed.height += height
    }
    
    return transformed
  }
  
  func changeWithTransform(_ changeTransform: CGSizeTransform) -> CGSize {
    var transformed = self
    if let width = changeTransform.width {
      transformed.width = width
    }
    
    if let height = changeTransform.height {
      transformed.height = height
    }
    
    return transformed
  }
}

public extension CGSize {
  func min(_ maxSize: CGSize) -> CGSize {
    return CGSize(width: Swift.min(maxSize.width, width), height: Swift.min(maxSize.height, height))
  }
}

//MARK: UIEdgeInsets

public struct UIEdgeInsetsTransform {
  public var top: CGFloat? // specify amount to inset (positive) for each of the edges. values can be negative to 'outset'
  public var left: CGFloat?
  public var bottom: CGFloat?
  public var right: CGFloat?
  
  public init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat?) {
    self.top = top; self.left = left; self.bottom = bottom; self.right = right
  }
  
  public static let zero: UIEdgeInsetsTransform = UIEdgeInsetsTransform(right: 0)
}

public extension UIEdgeInsets {
  func transform(_ transform: UIEdgeInsetsTransform) -> UIEdgeInsets {
    var transformed = self
    if let top = transform.top {
      transformed.top += top
    }
    
    if let left = transform.left {
      transformed.left += left
    }
    
    if let bottom = transform.bottom {
      transformed.bottom += bottom
    }
    
    if let right = transform.right {
      transformed.right += right
    }
    
    return transformed
  }
}

public extension UIEdgeInsets {
  /// A sum of top and bottom insets
  var verticalInsets: CGFloat {
    return top + bottom
  }
  
  /// A sum of right and left insets
  var horizontalInsets: CGFloat {
    return left + right
  }
}

public extension CGSize {
  var integral: CGSize {
    return CGSize(width: ceil(width), height: ceil(height))
  }
}
