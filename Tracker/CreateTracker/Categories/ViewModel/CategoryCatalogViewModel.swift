//
//  CategoryCatalogViewModel.swift
//  Tracker
//
//  Created by Dmitriy Noise on 10.07.2025.
//

import Foundation

final class CategoryCatalogViewModel {
    
    let categories: Observable<[TrackerCategory]> = Observable([])
    let selectedIndexPath: Observable<IndexPath?> = Observable(nil)
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    // MARK: - Init
    init(selectedIndexPath: IndexPath?) {
        self.selectedIndexPath.value = selectedIndexPath
        loadCategories()
    }
    
    // MARK: - Public Methods
    func numberOfRows() -> Int {
        categories.value.count
    }
    
    func cellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        let category = categories.value[indexPath.row]
        let isSelected = selectedIndexPath.value == indexPath
        
        return CategoryCellViewModel(title: category.title, isSelected: isSelected)
    }
    
    func selectRow(at indexPath: IndexPath) {
        selectedIndexPath.value = indexPath
    }
    
    func createCategory(title: String) {
        guard let trackerCategoryStore else { return }
        
        trackerCategoryStore.createCategory(
            TrackerCategory(title: title, trackers: [])
        )
        
        loadCategories()
    }
    
    // MARK: - Private methods
    private func loadCategories() {
        guard let trackerCategoryStore else {
            print("Ошибка загрузки категорий")
            return
        }
        
        categories.value = trackerCategoryStore.categories
    }
}
