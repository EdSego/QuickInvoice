//
//  InvoiceListView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/30/25.
//

import SwiftUI

struct InvoiceListView: View {
    //Share ViewModel globally across multiple views - dependency injection
    @EnvironmentObject var viewModel: InvoiceListViewModel
    //This way it will have to be initalized here
   // @StateObject var viewModel = InvoiceListViewModel()

    var body: some View {

        NavigationStack {
            
         
            Text("Invoices will appear here")
            Spacer()
            
                .toolbar {
                    ToolbarItem(placement: .principal){
                        Text("Invoices")
                            .font(.system(size: 25,weight: .bold, design: .monospaced))
                            .foregroundStyle(.primary)
                            .padding(.top, 20)
                    }
                }
            VStack {
            
                
                PrimaryButton(title: "Add Invoice",systemImage: "plus") {
                    viewModel.addInvoice()
                }
                
                .padding(.horizontal)
                .padding(.bottom, 20)
         
            }
            
            
        }
    }
}

#Preview {
    InvoiceListView()
}

