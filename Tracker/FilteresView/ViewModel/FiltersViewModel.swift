//
//  FilteresViewModel.swift
//  Tracker
//
//  Created by Dmitriy Noise on 18.07.2025.
//

import Foundation

final class FiltersViewModel {
    
    let selectedIndexPath: Observable<IndexPath?> = Observable(nil)
    private(set) var filteres = [
        Filter(title: "Все трекеры", isSelected: false, type: .all),
        Filter(title: "Трекеры на сегодня", isSelected: false, type: .today),
        Filter(title: "Завершенные", isSelected: false, type: .finished),
        Filter(title: "Не завершенные", isSelected: false, type: .unfinished)
    ]
    
    // MARK: - Init
    init(selectedIndexPath: IndexPath?) {
        guard let selectedIndexPath else {
            self.selectedIndexPath.value = loadSelectedFilter()
            return
        }
        
        self.selectedIndexPath.value = selectedIndexPath
    }
    
    // MARK: - Public Methods
    func numberOfRows() -> Int {
        filteres.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        let filter = filteres[indexPath.row]
        let isSelected = selectedIndexPath.value == indexPath
        
        return CategoryCellViewModel(title: filter.title, isSelected: isSelected)
    }
    
    func selectRow(at indexPath: IndexPath) {
        selectedIndexPath.value = indexPath
    }
    
    // MARK: - Private methods
    private func loadSelectedFilter() -> IndexPath? {
        let savedRawValue = UserDefaults.standard.string(forKey: "selectedFilter")
        let filterTypes = filteres.map { $0.type }
        let savedType = savedRawValue.flatMap { Constants.FilterType(rawValue: $0) }
        let selectedRow = filterTypes.firstIndex(of: savedType ?? .all) // .all если ничего не найдено
        let selectedIndexPath = selectedRow.map { IndexPath(row: $0, section: 0) }
        
        return selectedIndexPath
    }
}
