//
//  InvoiceListView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/30/25.
//

import SwiftUI

struct InvoiceListView: View {
    @State private var showingNewInvoice = false
    @EnvironmentObject var viewModel: InvoiceListViewModel
   // @StateObject var viewModel = InvoiceListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Welcome to Quick Invoice!")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                PrimaryButton(title: "Add Invoice", systemImage: "plus") {
                    showingNewInvoice = true  // Changed this
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Invoices")
                        .font(.system(size: 25, weight: .bold, design: .monospaced))
                        .foregroundStyle(.primary)
                        .padding(.top, 20)
                }
            }
            .sheet(isPresented: $showingNewInvoice) {
                NewInvoiceView()  
            }
        }
    }
}

#Preview {
    InvoiceListView()
}

