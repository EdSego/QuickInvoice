//
//  NewInvoiceView.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/3/25.
//

import SwiftUI
import SwiftData

struct NewInvoiceView: View {
    // Access to database
    @Environment(\.modelContext) private var modelContext
    // Dismiss this view (goback)
    @Environment(\.dismiss) private var dismiss
    
    // Invoice details
    @State private var invoiceDate = Date()
    @State private var jobNumber: String = ""
    
    @State private var client: Client? = nil
    @State private var showingClientForm = false
    
    @State private var lineItems: [LineItem] = []
    @State private var showingItemForm = false
    
    @State private var showingError = false
    @State private var errorMessage  = ""
    
    private var totalAmount: Double {
        lineItems.reduce(0) { $0 + $1.itemPrice }
    }
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: totalAmount)) ?? "$0.00"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:24){
                    VStack(alignment: .center, spacing:16){
                        Text("Invoice Details")
                            .font(Constants.headerFont)
                        HStack(spacing: 12) {
                            Text("Date")
                                .font(Constants.bodyFont)
                            Text("*").foregroundColor(Color(.systemRed))
                            DatePicker(
                                "Start Date",
                                selection: $invoiceDate,
                                displayedComponents: .date
                            ).datePickerStyle(.compact)
                                .labelsHidden()
                            
                            Text("Job #")
                                .font(Constants.bodyFont)
                            TextField("", text: $jobNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 120 )
                        }
                    }
                }.padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 5)
                
                VStack(alignment: .center, spacing:16){
                    HStack(alignment: .center, spacing:16){
                        Text("Client")
                            .font(Constants.bodyFont)
                        Text("*")
                            .foregroundColor(Color(.systemRed))
                            .font(Constants.bodyFont)
                        Spacer()
                        
                        if let client = client {
                            // Show client details
                            ClientInfoCard(client: client) {
                                // Edit/remove client
                                self.client = nil
                            }
                        } else {
                            // "+ Client" button
                            Button(action: {
                                showingClientForm = true
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
                    }.padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.15), radius: 5)
                }
                VStack(alignment: .center, spacing:16){
                    HStack(alignment: .center, spacing:16){
                        Text("Item/Service")
                            .font(Constants.bodyFont)
                        Text("*")
                            .foregroundColor(Color(.systemRed))
                            .font(Constants.bodyFont)
                        Spacer()
                        
                        if !lineItems.isEmpty {
                            ForEach(Array(lineItems.enumerated()), id: \.offset) { index, item in
                                LineItemCard(item: item) {
                                    // Remove this item
                                    lineItems.remove(at: index)
                                    // Update sort order for remaining items
                                }
                            }
                        }
                        Button(action: {
                            showingItemForm = true
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
                }.padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 5)
                
                VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("Total")
                                                .font(.headline)
                                            Spacer()
                                            Text(formattedTotal)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.15), radius: 5)
            }
        }
    }
    private func updateSortOrder() {
        lineItems.indices.forEach { lineItems[$0].sortOrder = $0 }
    }
}


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
}
