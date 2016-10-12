import Foundation
import QuartzCore

public protocol ScreenRoundable {
  func round(withScreenScale screenScale: CGFloat) -> Self
}

extension CGFloat: ScreenRoundable {
  public func round(withScreenScale screenScale: CGFloat) -> CGFloat {
    return (self * screenScale).rounded() / screenScale
  }
}

extension CGSize: ScreenRoundable {
  public func round(withScreenScale screenScale: CGFloat) -> CGSize {
    return CGSize(width: width.round(withScreenScale: screenScale),
                  height: height.round(withScreenScale: screenScale))
  }
}

extension CGPoint: ScreenRoundable {
  public func round(withScreenScale screenScale: CGFloat) -> CGPoint {
    return CGPoint(x: x.round(withScreenScale: screenScale),
                   y: y.round(withScreenScale: screenScale))
  }
}

extension CGRect: ScreenRoundable {
  public func round(withScreenScale screenScale: CGFloat) -> CGRect {
    return CGRect(origin: origin.round(withScreenScale: screenScale),
                  size: size.round(withScreenScale: screenScale))
  }
}
