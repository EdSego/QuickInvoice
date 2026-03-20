//
//  InvoiceRepository.swift
//  QuickInvoice
//
//  Created by Codex on 3/12/26.
//

import Foundation
import SwiftData

@MainActor
final class InvoiceRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAllInvoices() throws -> [Invoice] {
        let descriptor = FetchDescriptor<Invoice>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchLatestInvoice() throws -> Invoice? {
        var descriptor = FetchDescriptor<Invoice>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func createInvoice(
        invoiceNumber: String,
        draft: InvoiceDraft,
        isFinalized: Bool = false
    ) throws -> Invoice {
        let invoice = Invoice(
            invoiceNumber: invoiceNumber,
            jobNumber: draft.trimmedJobNumber,
            invoiceDate: draft.invoiceDate,
            client: draft.client,
            lineItems: draft.lineItems,
            isFinalized: isFinalized
        )

        modelContext.insert(invoice)
        try modelContext.save()
        return invoice
    }

    func save(_ invoice: Invoice) throws {
        invoice.updatedAt = Date()
        try modelContext.save()
    }

    func deleteInvoice(_ invoice: Invoice) throws {
        modelContext.delete(invoice)
        try modelContext.save()
    }
}
