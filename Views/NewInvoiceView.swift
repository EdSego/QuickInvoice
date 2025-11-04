//
//  NewInvoiceView.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/3/25.
//

import SwiftUI
import SwiftData

struct NewInvoiceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: NewInvoiceViewModel?
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            if let viewModel = viewModel {
                invoiceFormContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .onAppear {
                        // Initialize viewModel with modelContext from environment
                        self.viewModel = NewInvoiceViewModel(modelContext: modelContext)
                    }
            }
        }
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private func invoiceFormContent(viewModel: NewInvoiceViewModel) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Invoice Details Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Invoice Details")
                        .font(Constants.headerFont)
                    
                    HStack(spacing: 12) {
                        // Date
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Date")
                                    .font(Constants.bodyFont)
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            DatePicker(
                                "Invoice Date",
                                selection: Binding(
                                    get: { viewModel.invoiceDate },
                                    set: { viewModel.invoiceDate = $0 }
                                ),
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        }
                        
                        Spacer()
                        
                        // Job Number
                        VStack(alignment: .leading) {
                            Text("Job #")
                                .font(Constants.bodyFont)
                            TextField("Optional", text: Binding(
                                get: { viewModel.jobNumber },
                                set: { viewModel.jobNumber = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // MARK: - Client Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Client")
                            .font(Constants.headerFont)
                        Text("*")
                            .foregroundColor(.red)
                    }
                    
                    if let client = viewModel.client {
                        ClientInfoCard(client: client) {
                            viewModel.removeClient()
                        }
                    } else {
                        Button(action: {
                            viewModel.showingClientForm = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Client")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // MARK: - Items Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Items & Services")
                            .font(Constants.headerFont)
                        Text("*")
                            .foregroundColor(.red)
                    }
                    
                    if !viewModel.lineItems.isEmpty {
                        ForEach(Array(viewModel.lineItems.enumerated()), id: \.offset) { index, item in
                            LineItemCard(item: item) {
                                viewModel.removeLineItem(at: index)
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.showingItemForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Item/Service")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // MARK: - Total Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.formattedTotal)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                Color.clear.frame(height: 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("New Invoice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    if viewModel.createInvoice() {
                        dismiss()
                    }
                }
                .fontWeight(.semibold)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.showingError },
            set: { viewModel.showingError = $0 }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .sheet(isPresented: Binding(
            get: { viewModel.showingClientForm },
            set: { viewModel.showingClientForm = $0 }
        )) {
            Text("Client Form Coming Soon")
                .font(.title)
        }
        .sheet(isPresented: Binding(
            get: { viewModel.showingItemForm },
            set: { viewModel.showingItemForm = $0 }
        )) {
            Text("Item Form Coming Soon")
                .font(.title)
        }
    }
}


// MARK: - Supporting Views

struct ClientInfoCard: View {
    let client: Client
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.clientName)
                        .font(.headline)
                    Text(client.clientPhoneNum)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if let email = client.clientEmail {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let address = client.clientAddress {
                        Text(address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

struct LineItemCard: View {
    let item: LineItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.headline)
                if let description = item.itemDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text(item.formattedPrice)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    NewInvoiceView()
        .modelContainer(for: Invoice.self)
}
