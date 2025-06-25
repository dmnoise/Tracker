//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Dmitriy Noise on 18.06.2025.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext

    // MARK: - init
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    convenience init() {
        self.init(context: CoreDataStack.shared.context)
    }

    // MARK: - Public Properties
    var records: Set<TrackerRecord> {
        let request = TrackerRecordCoreData.fetchRequest()
        
        guard let result = try? context.fetch(request) else { return [] }
        
        return Set(result.compactMap { record in
            guard let trackerID = record.trackerId, let date = record.date else { return nil }
            return TrackerRecord(trackerID: trackerID, date: date)
        })
    }
    
    // MARK: - Public Methods
    func addRecord(_ record: TrackerRecord) throws {
        let entity = TrackerRecordCoreData(context: context)
        entity.trackerId = record.trackerID
        entity.date = record.date
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("Ошибка записи трекера :(\nError: \(error.localizedDescription)")
        }
    }
    
    func removeRecord(_ record: TrackerRecord) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            record.trackerID.uuidString as CVarArg,
            record.date as NSDate
        )
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            try context.save()
        } catch {
            context.rollback()
            print("Ошибка удаления трекера :(\nError: \(error)")
        }
    }

    func fetchRecordTracker(for trackerID: UUID) -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@", trackerID as CVarArg)
        
        let result = try? context.fetch(request)
        return result?.map { TrackerRecord(trackerID: $0.trackerId!, date: $0.date!) } ?? []
    }
}


