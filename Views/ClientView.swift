//
//  ClientView.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/6/25.
//

import SwiftUI

struct ClientFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Callback to pass the created client back to NewInvoiceView
    let onSave: (Client) -> Void
    
    // Form fields
    @State private var clientName: String = ""
    @State private var clientPhoneNum: String = ""
    @State private var clientEmail: String = ""
    @State private var clientAddress: String = ""
    
    // Validation
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Client Information Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Client Information")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        // Name (Required)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Name")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            TextField("Enter client name", text: $clientName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.words)
                        }
                        
                        // Phone Number (Required)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Phone")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("*")
                                    .foregroundColor(.red)
                            }
                            TextField("(555) 123-4567", text: $clientPhoneNum)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                        
                        // Email (Optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("client@example.com", text: $clientEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Address (Optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Address")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Street, City, State, ZIP", text: $clientAddress)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.words)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5)
                    
                    Color.clear.frame(height: 20)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("New Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveClient()
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func saveClient() {
        // Validate required fields
        guard !clientName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a client name."
            showingError = true
            return
        }
        
        guard !clientPhoneNum.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a phone number."
            showingError = true
            return
        }
        
        // Create the client object
        let newClient = Client(
            clientName: clientName.trimmingCharacters(in: .whitespaces),
            clientPhoneNum: clientPhoneNum.trimmingCharacters(in: .whitespaces),
            clientEmail: clientEmail.trimmingCharacters(in: .whitespaces).isEmpty ? nil : clientEmail.trimmingCharacters(in: .whitespaces),
            clientAddress: clientAddress.trimmingCharacters(in: .whitespaces).isEmpty ? nil : clientAddress.trimmingCharacters(in: .whitespaces)
        )
        
        // Pass the client back to the parent view
        onSave(newClient)
        
        // Dismiss the form
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    ClientFormView { client in
        print("Client saved: \(client.clientName)")
    }
}
