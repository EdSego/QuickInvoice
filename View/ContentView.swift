//
//  ContentView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
       ZStack(alignment: .top) {
            
            TabView {
                InvoiceListView()
                    .tabItem { Label("Home",systemImage: "house.fill") }
                    
                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person") }
            }
            
            
            
        }

    }
}

#Preview {
    ContentView()
}
