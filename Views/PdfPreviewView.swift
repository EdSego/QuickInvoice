//
//  PdfPreviewView.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 12/3/25.
//

import SwiftUI
import PDFKit

struct PDFPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    
    let pdfData: Data
    let invoice: Invoice
    let onDone: () -> Void
    
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // PDF Viewer
                PDFKitView(data: pdfData)
                    .ignoresSafeArea(edges: .horizontal)
                
                // Bottom Action Buttons
                VStack(spacing: 12) {
                    // Share Button
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Invoice")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Invoice Details
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(invoice.invoiceNumber)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(invoice.formattedDate)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(invoice.formattedPrice)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 4)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Invoice Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDone()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = savePDFToTemp() {
                    ShareSheet(items: [url])
                }
            }
        }
    }
    
    /// Saves the PDF data to a temporary file for sharing
    private func savePDFToTemp() -> URL? {
        let fileName = "Invoice-\(invoice.invoiceNumber).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: tempURL)
            return tempURL
        } catch {
            print("Error saving PDF to temp: \(error)")
            return nil
        }
    }
}

// MARK: - PDFKit View Wrapper

struct PDFKitView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        
        // Configuration
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.backgroundColor = UIColor.systemGroupedBackground
        
        // Load the PDF document
        if let document = PDFDocument(data: data) {
            pdfView.document = document
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update document if data changes (though unlikely in this use case)
        if let document = PDFDocument(data: data), uiView.document != document {
            uiView.document = document
        }
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        
        // Exclude some activity types if desired
        controller.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList
        ]
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - Preview

#Preview {
    // Create a mock invoice for preview
    let mockClient = Client(
        clientName: "John Doe",
        clientPhoneNum: "(555) 123-4567",
        clientEmail: "john@example.com",
        clientAddress: "123 Main St, City, ST 12345"
    )
    
    let mockItems = [
        LineItem(itemName: "Service 1", itemPrice: 100.00, itemDescription: "Description of service 1"),
        LineItem(itemName: "Service 2", itemPrice: 250.00)
    ]
    
    let mockInvoice = Invoice(
        invoiceNumber: "INVOICE001",
        jobNumber: "JOB123",
        invoiceDate: Date(),
        client: mockClient,
        lineItems: mockItems,
        isFinalized: false
    )
    
    if let pdfData = PDFGenerator.generateInvoicePDF(invoice: mockInvoice) {
        return PDFPreviewView(
            pdfData: pdfData,
            invoice: mockInvoice,
            onDone: { print("Done tapped") }
        )
    } else {
        return Text("Failed to generate PDF preview")
    }
}
