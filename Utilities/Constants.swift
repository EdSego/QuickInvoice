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
    
    static let titleFont: Font = .largeTitle.bold()
    static let headerFont: Font = .headline
    static let bodyFont: Font = .body
    static let captionFont: Font = .caption
    
    static let requiredFieldMessage = "Required"
    static let invalidEmailMessage = "Invalid Email"
    static let invalidPhoneMessage = "Invalid Phone Number"
    
    
}
