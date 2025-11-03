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
    
    private var totalaAmount: Double {
        lineItems.reduce(0) { $0 + $1.itemPrice }
    }
    
    private var formmattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: totalaAmount)) ?? "$0.00"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24){
                    
                }
            }
        }
    }
    
    
    
}
    


#Preview {
    NewInvoiceView()
}
