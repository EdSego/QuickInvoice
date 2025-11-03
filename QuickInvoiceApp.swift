//
//  QuickInvoiceApp.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/23/25.
//

import SwiftUI
import SwiftData

@main
struct QuickInvoiceApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: Invoice.self,
                Client.self,
                LineItem.self,
                PersonInfo.self,
                BusinessInfo.self
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
