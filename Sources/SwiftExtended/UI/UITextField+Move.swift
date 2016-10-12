
import Foundation
import UIKit

public extension UITextField {
  @objc(DSLTextFieldMovePosition)
  enum MovePosition: Int {
    case endOfFileName
  }

  @objc
  func moveCursor(to position: MovePosition) {
    switch position {
    case .endOfFileName:
      let endOfFileName: UITextPosition?

      if let offset = endOfFileNameOffset() {
        endOfFileName = self.position(from: beginningOfDocument, offset: offset)
      }
      else {
        endOfFileName = self.position(from: endOfDocument, offset: 0)
      }

      if let endOfFileName = endOfFileName {
        selectedTextRange = textRange(from: endOfFileName, to: endOfFileName)
      }
    }
  }

  // MARK: Helpers
  private func endOfFileNameOffset() -> Int? {
    guard let searchText = text else {return nil}

    let dotRange = (searchText as NSString).range(of: ".", options: NSString.CompareOptions.backwards)
    if dotRange.location != NSNotFound {
      return dotRange.location
    }
    return nil
  }
}
