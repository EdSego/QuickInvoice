//
//  InvoiceNumberService.swift
//  QuickInvoice
//
//  Created by Codex on 3/12/26.
//

import Foundation

final class InvoiceNumberService {
    let prefix: String
    let digits: Int

    init(prefix: String = "INVOICE", digits: Int = 3) {
        self.prefix = prefix
        self.digits = digits
    }

    func nextInvoiceNumber(after lastInvoiceNumber: String?) -> String {
        guard let lastInvoiceNumber,
              let number = extractSequence(from: lastInvoiceNumber) else {
            return formatted(number: 1)
        }

        return formatted(number: number + 1)
    }

    func nextInvoiceNumber(after invoice: Invoice?) -> String {
        nextInvoiceNumber(after: invoice?.invoiceNumber)
    }

    private func extractSequence(from invoiceNumber: String) -> Int? {
        let trimmed = invoiceNumber.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.hasPrefix(prefix) {
            return Int(trimmed.dropFirst(prefix.count))
        }

        let digitsOnly = trimmed.filter(\.isNumber)
        return Int(digitsOnly)
    }

    private func formatted(number: Int) -> String {
        "\(prefix)\(String(format: "%0\(digits)d", number))"
    }
}
