//
//  TrackerStore.swift
//  Tracker
//
//  Created by Dmitriy Noise on 18.06.2025.
//

import UIKit
import CoreData

struct TrackerStoreUpdate {
    let inserted: [IndexPath]
    let deleted: [IndexPath]
    let updated: [IndexPath]
    let moved: [(from: IndexPath, to: IndexPath)]
}

protocol TrackerStoreDelegate: AnyObject {
    func store(_ store: TrackerStore, didUpdate: TrackerStoreUpdate)
}

final class TrackerStore: NSObject {
    
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Private properties
    private let coreDataStack = CoreDataStack.shared
    private let uiColorMarshalling = UIColorMarshalling()
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    private var inserted: [IndexPath] = []
    private var deleted: [IndexPath] = []
    private var updated: [IndexPath] = []
    private var moved: [(from: IndexPath, to: IndexPath)] = []
    
    private let trackerCategoryStore = TrackerCategoryStore()

    // MARK: - init
    convenience override init() {
        try! self.init(context: CoreDataStack.shared.context)
    }

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    var trackers: [Tracker] {
        guard let objects = self.fetchedResultsController.fetchedObjects else {
            return []
        }
        
        return objects.compactMap { Tracker(from: $0) }
    }
    
    // MARK: - Public Methods
    func createTracker(_ trackerModel: Tracker, to category: String) {
        guard let trackerCategoryStore else { return }
        
        let tracker = TrackerCoreData(context: context)
        tracker.id = trackerModel.id
        tracker.name = trackerModel.name
        tracker.emoji = String(trackerModel.emoji)
        tracker.colorHex = uiColorMarshalling.hexString(from: trackerModel.color)
        tracker.schedule = trackerModel.schedule.toJSONString()
        tracker.category = trackerCategoryStore.fetchOrCreateCategory(named: category)
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения трекера :(\nError: \(error.localizedDescription)")
        }
    }
    
    func updateTracker(_ trackerModel: Tracker, to category: String) {
        guard let trackerCategoryStore else { return }
        
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerModel.id as CVarArg)
        
        do {
            guard let tracker = try context.fetch(request).first else { return }
            tracker.name = trackerModel.name
            tracker.emoji = String(trackerModel.emoji)
            tracker.colorHex = uiColorMarshalling.hexString(from: trackerModel.color)
            tracker.schedule = trackerModel.schedule.toJSONString()
            tracker.category = trackerCategoryStore.fetchOrCreateCategory(named: category)
            
            try context.save()
        } catch {
            print("Ошибка обновления трекера: \(error.localizedDescription)")
            context.rollback()
        }
    }
    
    func deleteTracker(at indexPath: IndexPath) {
        let trackerToDelete = fetchedResultsController.object(at: indexPath)
        context.delete(trackerToDelete)
        
        do {
            try context.save()
        } catch {
            print("Ошибка удаления трекера :(\nError: \(error.localizedDescription)")
        }
    }
    
    func getTracker(at indexPath: IndexPath) -> Tracker? {
        let findTracker = fetchedResultsController.object(at: indexPath)
        
        return Tracker(from: findTracker)
    }
    
    func deleteTracker(with id: UUID) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            guard let tracker = try context.fetch(request).first else { return }
            context.delete(tracker)
            try context.save()
        } catch {
            print("Ошибка удаления трекера по id :(\nError: \(error.localizedDescription)")
            context.rollback()
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        inserted = []
        deleted = []
        updated = []
        moved = []
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
            if let newIndexPath = newIndexPath {
                inserted.append(newIndexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                deleted.append(indexPath)
            }
        case .update:
            if let indexPath = indexPath {
                updated.append(indexPath)
            }
        case .move:
            if let from = indexPath, let to = newIndexPath {
                moved.append((from: from, to: to))
            }
        @unknown default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = TrackerStoreUpdate(
            inserted: inserted,
            deleted: deleted,
            updated: updated,
            moved: moved
        )
        delegate?.store(self, didUpdate: update)
    }
}

