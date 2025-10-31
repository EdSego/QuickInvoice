//
//  ContentView.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/23/25.
//
//
//  ContentView.swift
//  QuickInvoice
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Quick Invoice")
                    .font(.largeTitle)
                    .bold()
                
                Text("Ready to build!")
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
