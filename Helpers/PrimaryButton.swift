//
//  PrimaryButton.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 10/30/25.
//

import SwiftUI

struct PrimaryButton: View {
    
    var title: String
    var systemImage: String? = nil
    var color: Color = .blue
    var action: () -> Void

    
    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = systemImage {
                    Image(systemName: icon)
                        .imageScale(.medium)
                }
                Text(title)
                    .font(.headline)
            }
                        .foregroundColor(.white)
                       .padding(.vertical, 16)
                       .padding(.horizontal, 24)
                       .frame(maxWidth: .infinity)
                       .background(color)
                       .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                       .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

struct NavigationPrimaryButton<Destination: View>: View {
    var title: String
    var systemImage: String? = nil
    var color: Color = .blue
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                if let icon = systemImage {
                    Image(systemName: icon)
                        .imageScale(.medium)
                }
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .padding(.vertical, 16)           // same sizing as PrimaryButton
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

