//
//  NewInvoiceViewModel.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/3/25.
//

import Foundation
import SwiftUI

@Observable
class NewInvoiceViewModel {
    var draft = InvoiceDraft()
    
    var showingClientForm = false
    var showingItemForm = false
    var showingError = false
    var errorMessage = ""
    
    private let invoiceRepository: InvoiceRepository
    private let invoiceNumberService: InvoiceNumberService
    
    var totalAmount: Double {
        draft.totalAmount
    }
    
    var formattedTotal: String {
        AppFormatters.currency.string(from: NSNumber(value: totalAmount)) ?? "$0.00"
    }
    
    init(
        invoiceRepository: InvoiceRepository,
        invoiceNumberService: InvoiceNumberService
    ) {
        self.invoiceRepository = invoiceRepository
        self.invoiceNumberService = invoiceNumberService
    }
    
    
    func addClient(_ client: Client) {
        draft.client = client
        showingClientForm = false
    }
    
    func removeClient() {
        draft.client = nil
    }
    
    func addLineItems(_ items: [LineItem]) {
        draft.addLineItems(items)
        showingItemForm = false
    }
    
    func removeLineItem(at index: Int) {
        draft.removeLineItem(at: index)
    }
        
    func validate() -> Bool {
        guard draft.isReadyToSubmit else {
            errorMessage = draft.validationErrors.first ?? "Please complete the invoice details."
            showingError = true
            return false
        }
        
        return true
    }

    @MainActor func createInvoice() -> Invoice? {
        guard validate() else {
            return nil
        }
        
        do {
            let latestInvoice = try invoiceRepository.fetchLatestInvoice()
            let invoiceNumber = invoiceNumberService.nextInvoiceNumber(after: latestInvoice)
            return try invoiceRepository.createInvoice(
                invoiceNumber: invoiceNumber,
                draft: draft,
                isFinalized: false
            )
        } catch {
            errorMessage = "Failed to save invoice: \(error.localizedDescription)"
            showingError = true
            return nil
        }
    }
}
