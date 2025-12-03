//
//  PersonalInfoView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/2/25.
//

import SwiftUI
import SwiftData



struct PersonalInfoView: View {
    
    @EnvironmentObject var viewModel: PersonalInfoViewModel
    @FocusState private var focus: ProfileField?
    @Environment(\.modelContext) private var modelContext
    
    //Fetch all PersonInfo rows but should only be 0 or 1
    @Query private var people: [PersonInfo]
    
    // avoid reloading on every re-appear
    @State private var didLoadFromStore = false
    @State private var showToast = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Form {
                    
                    Section{
                        //   TextField("First Name", text: $viewModel.personalName)
                        FormTextField(label: "Full Name",required: true, text: $viewModel.personalName, error: (viewModel.touched.contains(.name) || viewModel.submitted) ? viewModel.errors[.name] : nil)
                            .focused($focus, equals: .name)
                            .submitLabel(.next)
                            .onSubmit {
                                focus = .phone
                            }
                            .onChange(of: viewModel.personalName) {
                                //viewModel.markTouched(.name)
                                viewModel.validate(.name)
                            }
                        
                        //                    if viewModel.shouldShow(.name) {
                        //                        Text(viewModel.errors[.name] ?? "")
                        //                                                       .font(.caption).foregroundColor(.red)
                        //                    }
                        
                        //                    if viewModel.touched.contains(.name), let err = viewModel.errors[.name] {
                        //                                                Text(err).font(.caption).foregroundColor(.red)
                        //                                            }
                    }
                    Section {
                        //                    TextField("Phone Number", text: $viewModel.phone)
                        //                        .keyboardType(.numberPad)
                        FormTextField(label: "Phone Number",required: true, text: $viewModel.phone,keyboard: .numberPad, error: (viewModel.touched.contains(.phone) || viewModel.submitted) ? viewModel.errors[.phone] : nil)
                            .focused($focus, equals: .phone)
                            .onChange(of: viewModel.phone) {
                                // viewModel.markTouched(.phone)
                                viewModel.validate(.phone)
                            }
                        
                        //                    if viewModel.touched.contains(.phone), let err = viewModel.errors[.phone] {
                        //                                                Text(err).font(.caption).foregroundColor(.red)
                        //                                            }
                    }
                    
                    Section {
                        FormTextField(label: "Email",required: true, text: $viewModel.email, keyboard: .emailAddress,error: (viewModel.touched.contains(.email) || viewModel.submitted) ? viewModel.errors[.email] : nil)
                        
                            .focused($focus, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focus = nil
                            }
                            .onChange(of: viewModel.email) {
                                //   viewModel.markTouched(.email)
                                viewModel.validate(.email)
                            }
                        
                        //                    if viewModel.touched.contains(.email), let err = viewModel.errors[.email] {
                        //                                                Text(err).font(.caption).foregroundColor(.red)
                        //                                            }
                        
                    }
                    
                    
                }
                .scrollDismissesKeyboard(.interactively)
                .onTapGesture {
                    focus = nil
                }
                // Reset transient UI when entering/leaving
                .onAppear {
                    viewModel.resetValidation()
                    focus = .name
                    
                    if !didLoadFromStore, let person = people.first {
                        viewModel.load(from: person)
                        didLoadFromStore = true
                    }
                }
                .onDisappear {
                    viewModel.resetValidation()
                    focus = nil
                }
                
                .safeAreaInset(edge: .bottom){
                    PrimaryButton(title: "Save", systemImage: "square.and.arrow.down"){
                        viewModel.save(focus: &focus, context: modelContext)
                        
                        withAnimation(.spring()){
                            showToast = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                            withAnimation(.spring()){
                                showToast = false
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    
                }
                
                if showToast {
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
                            .padding(.bottom, 110) // sits above Save button
                    }
                }
            }
            // Mark fields as touched when they LOSE focus
            .onChange(of: focus) { old, new in
                if let old, new != old {
                    viewModel.touched.insert(old)
                    viewModel.validate(old)
                }
            }
        
        
        .toolbar {
            
            ToolbarItem(placement: .principal){
                Text("Personal Info")
                    .font(.system(size: 25,weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
                    .padding(.top, 20)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focus = nil}
            }
            
            
        }
    }
        .ignoresSafeArea(.keyboard, edges: .bottom)
}
}
#Preview {
    PersonalInfoView()
        .environmentObject(PersonalInfoViewModel())
    
}
