//
//  NewInvoiceView.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/3/25.
//

import SwiftUI
import SwiftData

struct NewInvoiceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: NewInvoiceViewModel?
    
    // PDF Preview State
    @State private var showingPDFPreview = false
    @State private var generatedPDFData: Data?
    @State private var createdInvoice: Invoice?
    
    // Query for business info (for PDF generation)
    @Query private var businessInfos: [BusinessInfo]
    
    var body: some View {
        NavigationStack {
            if let viewModel = viewModel {
                invoiceFormContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .onAppear {
                        // Initialize viewModel with modelContext from environment
                        self.viewModel = NewInvoiceViewModel(modelContext: modelContext)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func invoiceFormContent(viewModel: NewInvoiceViewModel) -> some View {
        ScrollView {
            VStack(spacing: Constants.sectionSpacing) {
                
                // INVOICE DETAILS SECTION
                VStack(alignment: .leading, spacing: Constants.formSpacing) {
                    Text("Invoice Details")
                        .font(Constants.headerFont)
                    
                    HStack(spacing: 12) {
                        // Date
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Date")
                                    .font(Constants.bodyFont)
                                Text("*")
                                    .foregroundColor(Constants.requiredFieldColor)
                            }
                            DatePicker(
                                "Invoice Date",
                                selection: Binding(
                                    get: { viewModel.invoiceDate },
                                    set: { viewModel.invoiceDate = $0 }
                                ),
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        }
                        
                        Spacer()
                        
                        // Job Number
                        VStack(alignment: .leading) {
                            Text("Job #")
                                .font(Constants.bodyFont)
                            TextField("Optional", text: Binding(
                                get: { viewModel.jobNumber },
                                set: { viewModel.jobNumber = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.cornerRadius)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // CLIENT SECTION
                VStack(alignment: .leading, spacing: Constants.formSpacing) {
                    HStack {
                        Text("Client")
                            .font(Constants.headerFont)
                        Text("*")
                            .foregroundColor(Constants.requiredFieldColor)
                    }
                    
                    if let client = viewModel.client {
                        ClientInfoCard(client: client) {
                            viewModel.removeClient()
                        }
                    } else {
                        Button(action: {
                            viewModel.showingClientForm = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Client")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.primaryColor.opacity(0.1))
                            .foregroundColor(Constants.primaryColor)
                            .cornerRadius(Constants.cornerRadius)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.cornerRadius)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // ITEMS & SERVICES SECTION
                VStack(alignment: .leading, spacing: Constants.formSpacing) {
                    HStack {
                        Text("Items & Services")
                            .font(Constants.headerFont)
                        Text("*")
                            .foregroundColor(Constants.requiredFieldColor)
                    }
                    
                    if !viewModel.lineItems.isEmpty {
                        ForEach(Array(viewModel.lineItems.enumerated()), id: \.offset) { index, item in
                            LineItemCard(item: item) {
                                viewModel.removeLineItem(at: index)
                            }
                        }
                    }
                    
                    Button(action: {
                        viewModel.showingItemForm = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Item/Service")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Constants.primaryColor.opacity(0.1))
                        .foregroundColor(Constants.primaryColor)
                        .cornerRadius(Constants.cornerRadius)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.cornerRadius)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                // TOTAL SECTION
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.formattedTotal)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Constants.primaryColor)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(Constants.cornerRadius)
                .shadow(color: .black.opacity(0.05), radius: 5)
                
                Color.clear.frame(height: 20)
            }
            .padding(Constants.screenPadding)
        }
        .background(Constants.backgroundColor)
        .navigationTitle("New Invoice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    handleCreateInvoice(viewModel: viewModel)
                }
                .fontWeight(.semibold)
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.showingError },
            set: { viewModel.showingError = $0 }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .sheet(isPresented: Binding(
            get: { viewModel.showingClientForm },
            set: { viewModel.showingClientForm = $0 }
        )) {
            ClientFormView(modelContext: modelContext) { newClient in
                viewModel.client = newClient
                viewModel.showingClientForm = false
            }
        }
        .sheet(isPresented: Binding(
            get: { viewModel.showingItemForm },
            set: { viewModel.showingItemForm = $0 }
        )) {
            ItemFormView(modelContext: modelContext) { newItems in
                viewModel.lineItems.append(contentsOf: newItems)
                viewModel.showingItemForm = false
            }
        }
        .sheet(isPresented: $showingPDFPreview) {
            if let data = generatedPDFData,
               let invoice = createdInvoice {
                PDFPreviewView(
                    pdfData: data,
                    invoice: invoice
                ) {
                    // When done with preview, dismiss everything
                    dismiss()
                }
            } else {
                Text("Failed to load PDF preview.")
                    .font(.headline)
            }
        }
    }
    
    
    private func handleCreateInvoice(viewModel: NewInvoiceViewModel) {
        // Create and save the invoice
        guard let invoice = viewModel.createInvoice() else {
            // Error already shown by viewModel
            return
        }
        
        // Get business info (if available)
        let businessInfo = businessInfos.first
        
        // Generate PDF
        guard let pdfData = PDFGenerator.generateInvoicePDF(
            invoice: invoice,
            businessInfo: businessInfo
        ) else {
            // Show error if PDF generation fails
            print("Failed to generate PDF")
            return
        }
        
        // Store the data and show preview
        self.createdInvoice = invoice
        self.generatedPDFData = pdfData
        self.showingPDFPreview = true
    }
}

 

struct ClientInfoCard: View {
    let client: Client
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.clientName)
                        .font(.headline)
                    Text(client.clientPhoneNum)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if let email = client.clientEmail {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let address = client.clientAddress {
                        Text(address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Constants.accentColor)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Constants.primaryColor.opacity(0.1))
        .cornerRadius(Constants.cornerRadius)
    }
}

struct LineItemCard: View {
    let item: LineItem
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.headline)
                if let description = item.itemDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text(item.formattedPrice)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Constants.accentColor)
                    .font(.title3)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(Constants.cornerRadius)
    }
}


#Preview {
    NewInvoiceView()
        .modelContainer(for: Invoice.self)
}
