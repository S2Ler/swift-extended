import Foundation

public final class CancelToken {
  private let cancelationBlock: () -> Void

  public init(cancelationBlock: @escaping () -> Void) {
    self.cancelationBlock = cancelationBlock
  }

  public func cancel() {
    cancelationBlock()
  }
}
