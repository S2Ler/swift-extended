import Foundation

import CoreData
import Foundation
import UIKit

public protocol CellsConfigurator: class {
  func configureCell<Item: NSFetchRequestResult>(at indexPath: IndexPath, with item: Item)
}

/// A `FetchedResultsDelegateProvider` is responsible for providing a delegate object for an instance of `NSFetchedResultsController`.
public final class FetchedResultsDelegateProvider<Item: NSFetchRequestResult, ContainerViewType> {
  private var bridgedDelegate: BridgedFetchedResultsDelegate?
  private weak var containerView: UIView?
  private weak var cellsConfigurator: CellsConfigurator?
  private lazy var sectionChanges = [(changeType: NSFetchedResultsChangeType, sectionIndex: Int)]()
  private lazy var objectChanges = [(changeType: NSFetchedResultsChangeType, indexPaths: [IndexPath])]()
  private lazy var updatedObjects = [IndexPath: Item]()

  public var onControllerDidChangeContent: (() -> Void)?

  private init(cellsConfigurator: CellsConfigurator,
                   containerView: UIView) {
    self.cellsConfigurator = cellsConfigurator
    self.containerView = containerView
  }
}


extension FetchedResultsDelegateProvider where ContainerViewType: UICollectionView {

  // MARK: Collection views

  /**
   Initializes a new fetched results delegate provider for collection views.

   - parameter cellFactory:    The cell factory with which the fetched results controller delegate will configure cells.
   - parameter collectionView: The collection view to be updated when the fetched results change.

   - returns: A new `FetchedResultsDelegateProvider` instance.
   */
  public convenience init(cellsConfigurator: CellsConfigurator, collectionView: UICollectionView) {
    self.init(cellsConfigurator: cellsConfigurator, containerView: collectionView)
  }

  /// Returns the `NSFetchedResultsControllerDelegate` object for a collection view.
  public var collectionDelegate: NSFetchedResultsControllerDelegate {
    if bridgedDelegate == nil {
      bridgedDelegate = bridgedCollectionFetchedResultsDelegate()
    }
    return bridgedDelegate!
  }

  private weak var collectionView: UICollectionView? { return containerView as! UICollectionView? }

  private func bridgedCollectionFetchedResultsDelegate() -> BridgedFetchedResultsDelegate {
    let delegate = BridgedFetchedResultsDelegate(
      willChangeContent: { [unowned self] (controller) in
        self.sectionChanges.removeAll()
        self.objectChanges.removeAll()
        self.updatedObjects.removeAll()
      },
      didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) in
        self.sectionChanges.append((changeType, sectionIndex))
      },
      didChangeObject: { [unowned self] (controller, anyObject, indexPath: IndexPath?, changeType, newIndexPath: IndexPath?) in
        switch changeType {
        case .insert:
          if let insertIndexPath = newIndexPath {
            self.objectChanges.append((changeType, [insertIndexPath]))
          }
        case .delete:
          if let deleteIndexPath = indexPath {
            self.objectChanges.append((changeType, [deleteIndexPath]))
          }
        case .update:
          if let indexPath = indexPath {
            self.objectChanges.append((changeType, [indexPath]))
            self.updatedObjects[indexPath] = anyObject as? Item
          }
        case .move:
          if let old = indexPath, let new = newIndexPath {
            self.objectChanges.append((changeType, [old, new]))
          }
        @unknown default:
          fatalError()
        }
      },
      didChangeContent: { [unowned self] (controller) in
        self.collectionView?.performBatchUpdates({ [weak self] in
          self?.applyObjectChanges()
          self?.applySectionChanges()
          }, completion:{ [weak self] finished in
            self?.reloadSupplementaryViewsIfNeeded()
        })
        self.onControllerDidChangeContent?()
    })

    return delegate
  }

  private func applyObjectChanges() {
    for (changeType, indexPaths) in objectChanges {

      switch(changeType) {
      case .insert:
        collectionView?.insertItems(at: indexPaths)
      case .delete:
        collectionView?.deleteItems(at: indexPaths)
      case .update:
        if let indexPath = indexPaths.first,
          let item = updatedObjects[indexPath],
          collectionView != nil {
          cellsConfigurator?.configureCell(at: indexPath, with: item)
        }
      case .move:
        if let deleteIndexPath = indexPaths.first {
          self.collectionView?.deleteItems(at: [deleteIndexPath])
        }

        if let insertIndexPath = indexPaths.last {
          self.collectionView?.insertItems(at: [insertIndexPath])
        }
      @unknown default:
        fatalError()
      }
    }
  }

  private func applySectionChanges() {
    for (changeType, sectionIndex) in sectionChanges {
      let section = IndexSet(integer: sectionIndex)

      switch(changeType) {
      case .insert:
        collectionView?.insertSections(section)
      case .delete:
        collectionView?.deleteSections(section)
      default:
        break
      }
    }
  }

  private func reloadSupplementaryViewsIfNeeded() {
    if sectionChanges.count > 0 {
      collectionView?.reloadData()
    }
  }
}


extension FetchedResultsDelegateProvider where ContainerViewType: UITableView {

  // MARK: Table views

  /**
   Initializes a new fetched results delegate provider for table views.

   - parameter cellFactory: The cell factory with which the fetched results controller delegate will configure cells.
   - parameter tableView:   The table view to be updated when the fetched results change.

   - returns: A new `FetchedResultsDelegateProvider` instance.
   */
  public convenience init(cellsConfigurator: CellsConfigurator, tableView: UITableView) {
    self.init(cellsConfigurator: cellsConfigurator, containerView: tableView)
  }

  /// Returns the `NSFetchedResultsControllerDelegate` object for a table view.
  public var tableDelegate: NSFetchedResultsControllerDelegate {
    if bridgedDelegate == nil {
      bridgedDelegate = bridgedTableFetchedResultsDelegate()
    }
    return bridgedDelegate!
  }

  private weak var tableView: UITableView? { return containerView as! UITableView? }

  private func bridgedTableFetchedResultsDelegate() -> BridgedFetchedResultsDelegate {
    let delegate = BridgedFetchedResultsDelegate(
      willChangeContent: { [unowned self] (controller) in
        self.tableView?.beginUpdates()
      },
      didChangeSection: { [unowned self] (controller, sectionInfo, sectionIndex, changeType) in
        switch changeType {
        case .insert:
          self.tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
          self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
          break
        }
      },
      didChangeObject: { [unowned self] (controller, anyObject, indexPath, changeType, newIndexPath) in
        switch changeType {
        case .insert:
          if let insertIndexPath = newIndexPath {
            self.tableView?.insertRows(at: [insertIndexPath], with: .fade)
          }
        case .delete:
          if let deleteIndexPath = indexPath {
            self.tableView?.deleteRows(at: [deleteIndexPath], with: .fade)
          }
        case .update:
          if let indexPath = indexPath,
            self.tableView != nil,
            let item = anyObject as? Item {
            self.cellsConfigurator?.configureCell(at: indexPath, with: item)
          }
        case .move:
          if let deleteIndexPath = indexPath {
            self.tableView?.deleteRows(at: [deleteIndexPath], with: .fade)
          }

          if let insertIndexPath = newIndexPath {
            self.tableView?.insertRows(at: [insertIndexPath], with: .fade)
          }
        @unknown default:
          fatalError()
        }
      },
      didChangeContent: { [unowned self] (controller) in
        self.onControllerDidChangeContent?()
        self.tableView?.endUpdates()
    })

    return delegate
  }
}

/*
 This class is responsible for implementing the `NSFetchedResultsControllerDelegate` protocol.
 It avoids making `FetchedResultsDelegateProvider` inherit from `NSObject`, and keeps classes small and focused.
 */
@objc internal final class BridgedFetchedResultsDelegate: NSObject {

  typealias WillChangeContentHandler = (NSFetchedResultsController<NSFetchRequestResult>) -> Void
  typealias DidChangeSectionHandler = (NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsSectionInfo, Int, NSFetchedResultsChangeType) -> Void
  typealias DidChangeObjectHandler = (NSFetchedResultsController<NSFetchRequestResult>, Any, IndexPath?, NSFetchedResultsChangeType, IndexPath?) -> Void
  typealias DidChangeContentHandler = (NSFetchedResultsController<NSFetchRequestResult>) -> Void

  let willChangeContent: WillChangeContentHandler
  let didChangeSection: DidChangeSectionHandler
  let didChangeObject: DidChangeObjectHandler
  let didChangeContent: DidChangeContentHandler

  init(willChangeContent: @escaping WillChangeContentHandler,
       didChangeSection: @escaping DidChangeSectionHandler,
       didChangeObject: @escaping DidChangeObjectHandler,
       didChangeContent: @escaping DidChangeContentHandler) {

    self.willChangeContent = willChangeContent
    self.didChangeSection = didChangeSection
    self.didChangeObject = didChangeObject
    self.didChangeContent = didChangeContent
  }
}


extension BridgedFetchedResultsDelegate: NSFetchedResultsControllerDelegate {

  @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    willChangeContent(controller)
  }

  @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                        didChange sectionInfo: NSFetchedResultsSectionInfo,
                        atSectionIndex sectionIndex: Int,
                        for type: NSFetchedResultsChangeType) {
    didChangeSection(controller, sectionInfo, sectionIndex, type)
  }

  @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                        didChange anObject: Any,
                        at indexPath: IndexPath?,
                        for type: NSFetchedResultsChangeType,
                        newIndexPath: IndexPath?) {
    didChangeObject(controller, anObject, indexPath, type, newIndexPath)
  }

  @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    didChangeContent(controller)
  }
}
