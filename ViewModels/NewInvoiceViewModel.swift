//
//  NewInvoiceViewModel.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/3/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class NewInvoiceViewModel {
    
    var invoiceDate = Date()
    var jobNumber = ""
    var client: Client?
    var lineItems: [LineItem] = []
    
    var showingClientForm = false
    var showingItemForm = false
    var showingError = false
    var errorMessage = ""
    
    private let modelContext: ModelContext
    
    var totalAmount: Double {
        lineItems.reduce(0) { $0 + $1.itemPrice }
    }
    
    var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: totalAmount)) ?? "$0.00"
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    
    func addClient(_ client: Client) {
        self.client = client
        showingClientForm = false
    }
    
    func removeClient() {
        self.client = nil
    }
    
    func addLineItem(_ item: LineItem) {
        item.sortOrder = lineItems.count
        lineItems.append(item)
        showingItemForm = false
    }
    
    func removeLineItem(at index: Int) {
        lineItems.remove(at: index)
        updateSortOrder()
    }
    
    private func updateSortOrder() {
        for (index, _) in lineItems.enumerated() {
            lineItems[index].sortOrder = index
        }
    }
        
    func validate() -> Bool {
        if client == nil {
            errorMessage = "Please add a client"
            showingError = true
            return false
        }
        
        if lineItems.isEmpty {
            errorMessage = "Please add at least one item or service"
            showingError = true
            return false
        }
        
        return true
    }

    func createInvoice() -> Invoice? {
        // Validate first
        guard validate() else {
            return nil
        }
        
        // Generate invoice number
        let invoiceNumber = generateInvoiceNumber()
        
        // Create the invoice
        let invoice = Invoice(
            invoiceNumber: invoiceNumber,
            jobNumber: jobNumber.isEmpty ? nil : jobNumber,
            invoiceDate: invoiceDate,
            client: client,
            lineItems: lineItems,
            isFinalized: false
        )
        
        // Save to database
        modelContext.insert(invoice)
        
        // Try to save
        do {
            try modelContext.save()
            return invoice  // Return the created invoice
        } catch {
            errorMessage = "Failed to save invoice: \(error.localizedDescription)"
            showingError = true
            return nil
        }
    }
    
    // MARK: - Invoice Number Generation
    
    private func generateInvoiceNumber() -> String {
        // Query existing invoices to find the highest number
        let descriptor = FetchDescriptor<Invoice>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        guard let invoices = try? modelContext.fetch(descriptor),
              let lastInvoice = invoices.first else {
            // No invoices exist yet, start at 001
            return "INVOICE001"
        }
        
        // Extract number from last invoice (e.g., "INVOICE042" -> 42)
        let lastNumber = lastInvoice.invoiceNumber.replacingOccurrences(of: "INVOICE", with: "")
        
        if let number = Int(lastNumber) {
            let nextNumber = number + 1
            return String(format: "INVOICE%03d", nextNumber)
        }
        
        // Fallback if parsing fails
        return "INVOICE001"
    }
}
