//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Dmitriy Noise on 18.06.2025.
//

import CoreData

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTrackers
    case decodingErrorInvalidColorHex
}

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore, didUpdate: TrackerCategoryStoreUpdate)
}

final class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private properties
    private let coreDataStack = CoreDataStack.shared
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?

    // MARK: - init
    convenience init?(usingDefaultContext: Bool = true) {
        self.init(context: CoreDataStack.shared.context)
    }

    init?(context: NSManagedObjectContext) {
        self.context = context
        super.init()

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch {
            print("Ошибка fetch\nError: \(error)")
            return nil
        }
    }
    
    var categories: [TrackerCategory] {
        guard let object = self.fetchedResultsController.fetchedObjects else {
            return []
        }
        
        let categories = object.map( { category in
            let trackers = category.tracker
            let mapTrackers = trackers?.compactMap{ Tracker(from: $0 as! TrackerCoreData) }
            
            return TrackerCategory(title: category.title ?? "", trackers: mapTrackers ?? [])
        })
        
        return categories
    }
    
    // MARK: - Public Methods
    func createCategory(_ model: TrackerCategory) {
        let category = TrackerCategoryCoreData(context: context)
        category.title = model.title
        
        do {
            try context.save()
        } catch {
            print("Failed to save category :(\nError: \(error.localizedDescription)")
        }
    }

    func fetchOrCreateCategory(named title: String) -> TrackerCategoryCoreData {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)

        if let category = try? context.fetch(request).first {
            return category
        }

        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.title = title
        return newCategory
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let categories = try context.fetch(request)
            
            let trackerCategories = categories.map { category in
                let trackerCoreDataArray = category.tracker?.allObjects as? [TrackerCoreData] ?? []
                let trackers = trackerCoreDataArray.compactMap { Tracker(from: $0) }
                
                return TrackerCategory(title: category.title ?? "", trackers: trackers)
            }
            
            return trackerCategories
        } catch {
            print("Failed to fetch categories :(")
            return []
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        guard
            let insertedIndexes,
            let deletedIndexes,
            let updatedIndexes,
            let movedIndexes
        else {
            assertionFailure("Изменения категорий не были инициализированы")
            return
        }
        
        delegate?.store(
            self,
            didUpdate: TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                movedIndexes: movedIndexes
            )
        )
        
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath else {
                assertionFailure("indexPath is nil for \(type)")
                return
            }
            insertedIndexes?.insert(newIndexPath.item)
        case .delete:
            guard let indexPath else {
                assertionFailure("indexPath is nil for \(type)")
                return
            }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath else {
                assertionFailure("indexPath is nil for \(type)")
                return
            }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {
                assertionFailure("Move index paths are nil")
                return
            }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            break
        }
    }
}
