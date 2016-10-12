import Foundation

public final class ObjectObserver<Object: NSObject>: NSObject {
  private var observationContext = 0

  // MARK: - Init

  public typealias KeyPath = String

  private let observers: [KeyPath: (KeyPath, Object) -> Void]
  private let observersQueue: DispatchQueue

  public init(observers: [KeyPath: (KeyPath, Object) -> Void],
              observersQueue: DispatchQueue) {
    self.observers = observers
    self.observersQueue = observersQueue
  }

  // MARK: - Observing

  public var observableObject: Object? {
    willSet {
      removeObserving(from: observableObject)
    }

    didSet {
      observeObject(observableObject)
    }
  }

  private func observeObject(_ observableObject: Object?) {
    guard let observableObject = observableObject else {
      return
    }

    for keyPath in observers.keys {
      observableObject.addObserver(self, forKeyPath: keyPath, options: [], context: &observationContext)
    }
  }

  private func removeObserving(from observableObject: Object?) {
    guard let observableObject = observableObject else {
      return
    }

    for keyPath in observers.keys {
      observableObject.removeObserver(self, forKeyPath: keyPath, context: &observationContext)
    }
  }

  deinit {
    removeObserving(from: observableObject)
  }

  public override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey: Any]?,
                                    context: UnsafeMutableRawPointer?) {
    guard context == &observationContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    observersQueue.async { [weak self] in
      guard let this = self else { return }

      guard let keyPath = keyPath,
        let handler = this.observers[keyPath],
        let observableObject = this.observableObject else {
          return
      }

      handler(keyPath, observableObject)
    }
  }
}
