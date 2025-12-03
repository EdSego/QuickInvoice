//
//  BusinessInfoView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/2/25.
//

import SwiftUI
import SwiftData

struct BusinessInfoView: View {
    @EnvironmentObject var viewModel: BusinessInfoViewModel
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?
    // fetch all businessInfo rows
    @Query private var businesses: [BusinessInfo]
    
    
    @State private var didLoadFromStore = false
    @State private var showToast = false
    
    enum Field: Hashable {
        case businessName
        case phone
        case email
        case address
        case state
        case zip
        case license
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section {
                    FormTextField(label: "Business Name", required: true, text: $viewModel.businessName)
                        .focused($focusedField, equals: .businessName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .phone
                        }
                }
                
                Section {
                    FormTextField(label: "Phone Number", required: true, text: $viewModel.businessPhoneNum,keyboard: .namePhonePad)
                        .focused($focusedField, equals: .phone)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .email
                        }
                }
                
                Section {
                    FormTextField(label: "Email", required: true, text: $viewModel.businessEmail, keyboard: .emailAddress)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .address
                        }
                }
                
                Section {
                    
                    if let address = Binding($viewModel.businessAddress){
                        
                        FormTextField(label: "Address", required: false, text: address)
                            .focused($focusedField, equals: .address)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .state
                            }
                    } else {
                        
                    }
                    
                }
                
                Section {
                    
                    HStack(spacing: 25) {
                        
                        if let state = Binding($viewModel.businessState){
                            FormTextField(label: "State", text: state,widthFactor: 0.5)
                                .focused($focusedField, equals: .state)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .zip
                                }
                        } else {
                            
                        }
                        
                        if let zip = Binding($viewModel.businessZipCode){
                            FormTextField(label: "Zip Code", text: zip,keyboard: .numberPad, widthFactor: 0.5)
                                .focused($focusedField, equals: .zip)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .license
                                }
                        } else {
                            
                        }
                        
                    }
                    
                }
                Section {
                    if let businessLic = Binding($viewModel.businessLicNum){
                        FormTextField(label: "Business License", text: businessLic)
                            .focused($focusedField, equals: .license)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedField = nil
                            }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onTapGesture {
                focusedField = nil //dismisses keyboard when tapping outside
            }
            
            .onAppear {
                focusedField = .businessName
                
                if !didLoadFromStore, let info = businesses.first {
                    viewModel.load(from: info)
                    didLoadFromStore = true
                }
            }
            .onDisappear{
                focusedField = nil
            }
            
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Save",systemImage: "square.and.arrow.down"){
                    viewModel.save(context: modelContext)
                    
                    withAnimation(.spring()){
                        showToast = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                        withAnimation(.spring()) {
                            showToast = false
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.vertical,4)
            }
            
            
            if showToast{
                VStack {
                    Spacer()
                    
                    Text("Saved ✓")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                        .shadow(radius: 4)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 110) // above Save button
                }
            }
        }
        
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                Text("Business Info")
                    .font(.system(size: 25,weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
                    .padding(.top, 20)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil}
            }
            
        }
        
        
    }

}

#Preview {
    BusinessInfoView()
        .environmentObject(BusinessInfoViewModel())
}
