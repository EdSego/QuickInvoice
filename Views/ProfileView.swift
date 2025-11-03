//
//  ProfileView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/30/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: InvoiceListViewModel
    init() {
        _viewModel = StateObject(wrappedValue: InvoiceListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Text("Hello!.. client name!")
                .padding(.bottom, 60)

            
                .toolbar {
                    ToolbarItem(placement: .principal){
                        Text("Profile")
                            .font(.system(size: 25,weight: .bold, design: .monospaced))
                            .foregroundStyle(.primary)
                            .padding(.top, 20)
                    }
                }
            
                .padding(.top, 50)
            Circle()
                .fill(Color.gray.opacity(0.2))
                                    .frame(width: 200, height: 200)
                                    .overlay(Image(systemName: "person.fill").font(.system(size: 60)))
            Spacer()

            VStack(spacing: 20){
                NavigationPrimaryButton(
                    title: "Personal Information",
                    systemImage: "person.text.rectangle",
                    destination: PersonalInfoView()
                )
                NavigationPrimaryButton (
                    title: "Business Information",
                    systemImage: "building.2",
                    destination: BusinessInfoView()
                    
                )
            }
            
            .padding(.horizontal)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
     
        }
      
    }
    
}

#Preview {
    ProfileView()
}
