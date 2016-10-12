import UIKit

@objc(DSLXibDimensionHelper)
open class XibDimensionHelper: NSObject {
  @IBOutlet var onePixelConstraint: NSLayoutConstraint? {
    didSet {
      if let newConstraint = onePixelConstraint {
        newConstraint.constant = newConstraint.constant / UIScreen.main.scale
      }
    }
  }
}
