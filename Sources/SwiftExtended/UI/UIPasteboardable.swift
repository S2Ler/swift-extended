import Foundation
import UIKit

public protocol UIPasteboardable {
  func copyToPasteboard(_ pasteboard: UIPasteboard)
}
