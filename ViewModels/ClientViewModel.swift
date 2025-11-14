//
//  ClientViewModel.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/13/25.
//

import SwiftUI
import SwiftData

@Observable
class ClientViewModel {

    private let modelContext: ModelContext?

    var clientName: String = ""
    var clientPhoneNum: String = ""
    var clientEmail: String = ""
    var clientAddress: String = ""

    var showingError: Bool = false
    var errorMessage: String = ""

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    private func validate() -> Bool {
        if clientName.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please enter a client name."
            showingError = true
            return false
        }

        if clientPhoneNum.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please enter a phone number."
            showingError = true
            return false
        }

        return true
    }

    func createClient() -> Client? {

        guard validate() else {
            return nil
        }

        let newClient = Client(
            clientName: clientName.trimmingCharacters(in: .whitespaces),
            clientPhoneNum: clientPhoneNum.trimmingCharacters(in: .whitespaces),
            clientEmail: clientEmail.trimmingCharacters(in: .whitespaces).isEmpty ? nil : clientEmail,
            clientAddress: clientAddress.trimmingCharacters(in: .whitespaces).isEmpty ? nil : clientAddress
        )

        if let context = modelContext {
            context.insert(newClient)
            do {
                try context.save()
            } catch {
                print(" Failed to save client: \(error)")
            }
        }

        return newClient
    }

    func reset() {
        clientName = ""
        clientPhoneNum = ""
        clientEmail = ""
        clientAddress = ""
        showingError = false
        errorMessage = ""
    }
}
