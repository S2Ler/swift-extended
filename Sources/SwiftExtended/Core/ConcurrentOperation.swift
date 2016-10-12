import Foundation

/// An abstract class that makes building simple asynchronous operations easy.
/// Subclasses must implement `execute()` to perform any work and call
/// `finish()` when they are done. All `NSOperation` work will be handled
/// automatically.
open class ConcurrentOperation: Operation {
  @objc(DSLConcurrentOperationState)
  private enum State: Int {
    case ready
    case executing
    case finished
  }

  private let stateQueue = DispatchQueue(label: "com.diejmon.operation.state", attributes: .concurrent)

  private var rawState = State.ready

  @objc
  private dynamic var state: State {
    get {
      return stateQueue.sync(execute: { rawState })
    }
    set {
      willChangeValue(forKey: #keyPath(state))
      stateQueue.sync(flags: .barrier, execute: { rawState = newValue })
      didChangeValue(forKey: #keyPath(state))
    }
  }

  public final override var isReady: Bool {
    return state == .ready && super.isReady
  }

  public final override var isExecuting: Bool {
    return state == .executing
  }

  public final override var isFinished: Bool {
    return state == .finished
  }

  // MARK: - NSObject

  @objc
  private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
    return [#keyPath(state)]
  }

  @objc
  private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
    return [#keyPath(state)]
  }

  @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
    return [#keyPath(state)]
  }

  // MARK: - Foundation.Operation

  public override final func start() {
    super.start()

    guard !isCancelled else {
      finish()
      return
    }

    state = .executing
    execute()
  }

  // MARK: - Public

  /// Subclasses must implement this to perform their work and they must not
  /// call `super`. The default implementation of this function throws an
  /// exception.
  open func execute() {
    fatalError("Subclasses must implement `execute`.")
  }

  /// Call this function after any work is done or after a call to `cancel()`
  /// to move the operation into a completed state.
  public final func finish() {
    state = .finished
  }
}
