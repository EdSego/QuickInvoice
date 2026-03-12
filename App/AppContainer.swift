//
//  AppContainer.swift
//  QuickInvoice
//
//  Created by Codex on 3/12/26.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class AppContainer: ObservableObject {
    let invoiceRepository: InvoiceRepository
    let profileRepository: ProfileRepository
    let invoiceNumberService: InvoiceNumberService

    init(modelContext: ModelContext) {
        self.invoiceRepository = InvoiceRepository(modelContext: modelContext)
        self.profileRepository = ProfileRepository(modelContext: modelContext)
        self.invoiceNumberService = InvoiceNumberService()
    }
}
