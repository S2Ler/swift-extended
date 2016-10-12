import Foundation

public class NSKeyValueObservationBag {
  private var observations: [NSKeyValueObservation] = []
  private let lock = NSLock()

  public init() {}

  public func add(_ observation: NSKeyValueObservation) {
    lock.lock()
    observations.append(observation)
    lock.unlock()
  }

  public func clear() {
    lock.lock()
    observations.removeAll()
    lock.unlock()
  }
}

public extension NSKeyValueObservation {
  func add(to bag: NSKeyValueObservationBag) {
    bag.add(self)
  }
}
