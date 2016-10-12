import Foundation

extension DispatchQueue {
  public func delay(by interval: TimeInterval, closure: @escaping () -> Void) {
    let time = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(interval * 1000))
    asyncAfter(deadline: time, execute: closure)
  }
}
