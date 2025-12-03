
import SwiftUI
import SwiftData

struct ItemFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // Callback back to parent
    let onSave: ([LineItem]) -> Void
    
    // ViewModel
    @State private var viewModel: ItemViewModel
    
    // Init with optional modelContext
    init(modelContext: ModelContext? = nil, onSave: @escaping ([LineItem]) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ItemViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // HEADER
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add Items & Services")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Add all items for this invoice")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // ITEMS LIST
                    ForEach(viewModel.items.indices, id: \.self) { index in
                        ItemCard(
                            item: $viewModel.items[index],
                            itemNumber: index + 1,
                            canDelete: viewModel.items.count > 1,
                            onDelete: {
                                withAnimation {
                                    viewModel.removeItem(at: index)
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                    
                    // ADD MORE BUTTON
                    Button(action: {
                        withAnimation {
                            viewModel.addNewItem()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Another Item")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Color.clear.frame(height: 20)
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Items & Services")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveItems() }
                        .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    private func saveItems() {
        if let items = viewModel.createLineItems() {
            onSave(items)
            dismiss()
        }
    }
}

// MARK: - Item Card Component

struct ItemCard: View {
    @Binding var item: ItemFormData
    let itemNumber: Int
    let canDelete: Bool
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // HEADER
            HStack {
                Text("Item \(itemNumber)")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                if canDelete {
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
            }
            
            // NAME
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Name")
                    Text("*").foregroundColor(.red)
                }
                TextField("Item or service name", text: $item.itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // PRICE
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Price")
                    Text("*").foregroundColor(.red)
                }
                HStack {
                    Text("$")
                        .foregroundColor(.secondary)
                    TextField("0.00", text: $item.itemPrice)
                        .keyboardType(.decimalPad)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            // DESCRIPTION
            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                TextField("Optional description", text: $item.itemDescription, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

#Preview {
    ItemFormView { items in
        print("Saved \(items.count) items")
    }
}




