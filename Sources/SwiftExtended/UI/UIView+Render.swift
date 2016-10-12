import UIKit

public extension UIView {
  @available(iOS 10.0, *)
  func renderToImage(afterScreenUpdates: Bool = false) -> UIImage {
    let rendererFormat = UIGraphicsImageRendererFormat.default()
    rendererFormat.opaque = isOpaque
    let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)

    let snapshotImage = renderer.image { _ in
      drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
    }
    return snapshotImage
  }
}
