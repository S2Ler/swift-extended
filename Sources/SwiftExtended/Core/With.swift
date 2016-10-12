import Foundation

public func with<T>(_ object: T, change: (inout T) -> Void) -> T {
  var copy = object
  change(&copy)
  return copy
}
