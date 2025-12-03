//
//  LabeledRequiredField.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/11/25.
//

import SwiftUI
struct FormTextField: View {
    
    var label: String
    var required: Bool = false
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var error: String? = nil
    var widthFactor: CGFloat = 1.0 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if required {
                    Text("*")
                        .foregroundStyle(.red)
                }
            }
            TextField("", text: $text)
                .keyboardType(keyboard)
                .textFieldStyle(.roundedBorder)
            if let error, !error.isEmpty{
                Text(error).font(.caption).foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity * widthFactor, alignment: .leading)
    }
}
