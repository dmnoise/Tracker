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
    
    func removeRecord(_ record: TrackerRecord, ignoreData: Bool = false) throws {
        print("start delet, ignore date: \(ignoreData)")
        
        let predicate = ignoreData
        ? NSPredicate(format: "trackerId == %@", record.trackerID.uuidString as CVarArg)
        : predicateForTrackerId(record.trackerID, onDay: record.date)
        
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = predicate
        
        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
                print("ok")
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
        
        do {
            let result = try context.fetch(request)
            return result.compactMap { record in
                guard
                    let id = record.trackerId,
                    let date = record.date
                else { return nil }
                
                return TrackerRecord(trackerID: id, date: date)
            }
        } catch {
            print("Ошибка fetch\nError: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Private methods
    private func predicateForTrackerId(_ trackerId: UUID, onDay date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return NSPredicate(
            format: "trackerId == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as NSDate,
            endOfDay as NSDate
        )
    }
}


