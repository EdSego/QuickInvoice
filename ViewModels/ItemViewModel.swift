
import Foundation
import SwiftData

@Observable
class ItemViewModel {
    
    // Model Context (optional - for future features)
    private let modelContext: ModelContext?
    
    // Form data
    var items: [ItemFormData] = [ItemFormData()]
    
    // UI State
    var showingError: Bool = false
    var errorMessage: String = ""
    
    // MARK: - Initialization
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    // MARK: - Item Management
    
    func addNewItem() {
        items.append(ItemFormData())
    }
    
    func removeItem(at index: Int) {
        guard index < items.count && items.count > 1 else { return }
        items.remove(at: index)
    }
    
    
    func createLineItems() -> [LineItem]? {
        // Validate all items
        for (index, item) in items.enumerated() {
            // Validate name
            guard !item.itemName.trimmingCharacters(in: .whitespaces).isEmpty else {
                errorMessage = "Please enter a name for Item \(index + 1)."
                showingError = true
                return nil
            }
            
            // Validate price
            guard let price = Double(item.itemPrice), price > 0 else {
                errorMessage = "Please enter a valid price for Item \(index + 1)."
                showingError = true
                return nil
            }
        }
        
        // Convert ItemFormData to LineItem
        let lineItems = items.compactMap { formData -> LineItem? in
            guard let price = Double(formData.itemPrice) else { return nil }
            
            return LineItem(
                itemName: formData.itemName.trimmingCharacters(in: .whitespaces),
                itemPrice: price,
                itemDescription: formData.itemDescription.trimmingCharacters(in: .whitespaces).isEmpty ? nil : formData.itemDescription.trimmingCharacters(in: .whitespaces)
            )
        }
        
        return lineItems
    }
}

// MARK: - Item Form Data Model

struct ItemFormData: Identifiable {
    let id = UUID()
    var itemName: String = ""
    var itemPrice: String = ""
    var itemDescription: String = ""
}




