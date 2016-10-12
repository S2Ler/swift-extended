import Foundation

public final class WorkGroup<WorkName: RawRepresentable> where WorkName.RawValue == String {
  private let workGroup = DispatchGroup()
  private let name: String

  private var worksCount: Int = 0
  private var activeWorkNames: Array<WorkName> = .init()
  private let lock: NSLock = .init()
  
  public var onEnter: ((_ workName: WorkName) -> Void)?
  public var onLeave: ((_ workName: WorkName) -> Void)?
  
  public init(name: String) {
    self.name = name
  }
  
  public func enter(_ workName: WorkName) {
    workGroup.enter()
    lock.lock()
    worksCount += 1
    activeWorkNames.append(workName)
    lock.unlock()
    onEnter?(workName)
  }

  public func leave(_ workName: WorkName) {
    workGroup.leave()
    lock.lock()
    worksCount -= 1
    
    let indexOfWorkName = activeWorkNames.firstIndex { (obj) -> Bool in
      return obj.rawValue == workName.rawValue
    }
    if let indexToDelete = indexOfWorkName {
      activeWorkNames.remove(at: indexToDelete)
    }
    lock.unlock()
    
    onLeave?(workName)
  }

  public func notify(_ queue: DispatchQueue, block: @escaping ()->()) {
    workGroup.notify(queue: queue, execute: block)
  }
}

public extension WorkGroup {
  func hasWorkWithName(_ workName: WorkName) -> Bool {
    lock.lock(); defer {
      lock.unlock()
    }
    return activeWorkNames.contains(where: { (obj) -> Bool in
      return obj.rawValue == workName.rawValue
    })
  }
}
