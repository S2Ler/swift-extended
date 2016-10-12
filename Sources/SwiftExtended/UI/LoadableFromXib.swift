import UIKit

/// Describes an object which can be instantiated from nib
public protocol LoadableFromXib: class {
  static var nibName: String { get }
  /// Bundle where xib is located
  /// - note: Default implementation returns Bundle where addopted class is located
  static var nibBundle: Bundle? { get }
}

public extension LoadableFromXib {
  static var nibBundle: Bundle? {
    return Bundle(for: self)
  }

  static var nibName: String {
    return String(describing: self)
  }
  
  static func makeFromXib(owner: Any? = nil, options: [UINib.OptionsKey: Any]? = nil) -> Self {
    let nib = UINib(nibName: nibName, bundle: nibBundle)
    let loadedObjects = nib.instantiate(withOwner: owner, options: options)

    for obj in loadedObjects {
      if let selfObj = obj as? Self {
        return selfObj
      }
    }

    fatalError("Can't find object with type \(type(of: self))")
  }
}
