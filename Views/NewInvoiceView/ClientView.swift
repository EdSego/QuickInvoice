//
//  ClientView.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 11/6/25.
//


import SwiftUI
import SwiftData

struct ClientFormView: View {

    @Environment(\.dismiss) private var dismiss

    // Callback back to parent
    let onSave: (Client) -> Void

    // ViewModel
    @State private var viewModel: ClientViewModel

    // Init with optional modelContext
    init(modelContext: ModelContext? = nil, onSave: @escaping (Client) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ClientViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Client Information")
                            .font(.title2)
                            .fontWeight(.bold)

                        // NAME
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Name")
                                Text("*").foregroundColor(.red)
                            }
                            TextField("Enter client name", text: $viewModel.clientName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        // PHONE
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Phone")
                                Text("*").foregroundColor(.red)
                            }
                            TextField("(555) 123-4567", text: $viewModel.clientPhoneNum)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }

                        // EMAIL
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                            TextField("client@example.com", text: $viewModel.clientEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }

                        // ADDRESS
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Address")
                            TextField("Street, City, State, ZIP", text: $viewModel.clientAddress)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    Color.clear.frame(height: 20)
                }
                .padding()
            }
            .navigationTitle("New Client")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveClient() }
                        .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }

    private func saveClient() {
        if let client = viewModel.createClient() {
            onSave(client)
            dismiss()
        }
    }
}

#Preview {
    ClientFormView { client in
        print("Saved: \(client.clientName)")
    }
}
