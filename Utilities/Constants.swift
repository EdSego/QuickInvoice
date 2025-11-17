//
//  Constants.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 10/31/25.
//

import SwiftUI

enum Constants {
    static let invoicePrefix = "invoice"
    
    static let incoiceStartNumber = 1
    
    static let invoiceNumberDigits = 3
    
    static let screenPadding: CGFloat = 20
    static let formSpacing: CGFloat = 10
    static let sectionSpacing: CGFloat = 20
    static let cornerRadius: CGFloat = 12
    
    static let primaryColor = Color.blue
    static let accentColor = Color.red
    
    // backgroud for forms
    static let backgroundColor = Color(.systemGroupedBackground)
    static let requiredFieldColor = Color.red
    
    static let titleFont: Font = .system(size: 34, weight: .bold, design: .monospaced)
    static let headerFont: Font = .system(size: 25, weight: .bold, design: .monospaced)
    static let bodyFont: Font = .system(size: 18, weight: .regular, design: .monospaced)
    static let captionFont: Font = .system(size: 14, weight: .regular, design: .monospaced)
       
    
    static let requiredFieldMessage = "Required"
    static let invalidEmailMessage = "Invalid Email"
    static let invalidPhoneMessage = "Invalid Phone Number"
    
    
}
