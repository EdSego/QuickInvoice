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
                       .padding(.vertical, 12)
                       .padding(.horizontal, 20)
                       .frame(maxWidth: .infinity)
                       .background(color)
                       .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                       .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
