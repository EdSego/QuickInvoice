//
//  Invoice.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 10/31/25.
//

import Foundation
import SwiftData

@Model
final class Invoice{
    var invoiceNumber: String
    
    var jobNumber: String?
    
    var invoiceDate: Date
        
    var client: Client?
    
    @Relationship(deleteRule: .cascade)
    var lineItems: [LineItem]
    
    var createdAt: Date
    
    var updatedAt: Date?
    
    var isFinalized: Bool
    
    var pdfFilePath:String?
    
    var totalCents: Int {
        return lineItems.reduce(0) {$0 + $1.itemPriceCents}
    }
    
    var totalAmount: Double {
        Double(totalCents) / 100.0
    }
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: totalAmount)) ?? "$0.00"
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: invoiceDate)
    }
    
    
    
    init (
        invoiceNumber: String,
        jobNumber: String? = nil,
        invoiceDate: Date = Date(),
        client: Client? = nil,
        lineItems: [LineItem] = [],
        isFinalized: Bool = false,
    ){
        self.invoiceNumber = invoiceNumber
        self.jobNumber = jobNumber
        self.invoiceDate = invoiceDate
        self.client = client
        self.lineItems = lineItems
        self.createdAt = Date()
        self.isFinalized = isFinalized
        self.pdfFilePath = nil
        
    }
    
    
    
    var isValid: Bool {
        // must have valid invoice number
        guard !invoiceNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        // must have valid client
        guard let client = client, client.isValid else {
            return false
        }
        // must have at least one valid line item
        guard !lineItems.isEmpty else {
            return false
        }
        return lineItems.allSatisfy{$0.isValid}
    }
    
    var validationErrors: [String] {
        var errors: [String] = []
        
        if client == nil {
            errors.append("Invoice must have a valid client")
        } else if let client = client, !client.isValid {
            errors.append("Client has validation errors")
        }
        
        if lineItems.isEmpty {
            errors.append( "Invoice must have at least one line item")
        }
        let invalidItems = lineItems.filter { !$0.isValid }
        if !invalidItems.isEmpty {
            errors.append("Some items have missing information")
        }
        
        return errors
    }
    
    
}
