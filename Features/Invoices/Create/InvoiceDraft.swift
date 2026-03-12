//
//  InvoiceDraft.swift
//  QuickInvoice
//
//  Created by Codex on 3/12/26.
//

import Foundation

struct InvoiceDraft {
    var invoiceDate: Date = Date()
    var jobNumber: String = ""
    var client: Client?
    var lineItems: [LineItem] = []

    var trimmedJobNumber: String? {
        let trimmed = jobNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var totalCents: Int {
        lineItems.reduce(0) { $0 + $1.itemPriceCents }
    }

    var totalAmount: Double {
        Double(totalCents) / 100.0
    }

    var hasClient: Bool {
        client?.isValid == true
    }

    var hasLineItems: Bool {
        !lineItems.isEmpty && lineItems.allSatisfy(\.isValid)
    }

    var isReadyToSubmit: Bool {
        hasClient && hasLineItems
    }

    var validationErrors: [String] {
        var errors: [String] = []

        if !hasClient {
            errors.append("Please add a valid client.")
        }

        if lineItems.isEmpty {
            errors.append("Please add at least one item or service.")
        } else if !lineItems.allSatisfy(\.isValid) {
            errors.append("Please fix the incomplete item or service details.")
        }

        return errors
    }

    mutating func addLineItems(_ items: [LineItem]) {
        let startIndex = lineItems.count
        for (offset, item) in items.enumerated() {
            item.sortOrder = startIndex + offset
        }
        lineItems.append(contentsOf: items)
    }

    mutating func removeLineItem(at index: Int) {
        guard lineItems.indices.contains(index) else { return }
        lineItems.remove(at: index)

        for (offset, item) in lineItems.enumerated() {
            item.sortOrder = offset
        }
    }
}
