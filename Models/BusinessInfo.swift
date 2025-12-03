//
//  BusinessInfo.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 10/31/25.
//

import Foundation
import SwiftData

@Model
final class BusinessInfo{

    var businessName: String
    
    var businessPhoneNum: String
    
    var businessEmail: String
    
    var businessAddress: String?
    
    var businessLicNum: String?
    
    var businessState: String?
    
    var businessZipCode: String?

    
    var createdAt: Date
    var updateAt: Date
    
    init (
        businessName: String = "",
        businessPhoneNum: String = "",
        businessEmail: String = "",
        businessAddress: String? = nil,
        businessLicNum: String? = nil,
    ){
        self.businessName = businessName
        self.businessPhoneNum = businessPhoneNum
        self.businessEmail = businessEmail
        self.businessAddress = businessAddress
        self.businessLicNum = businessLicNum
        self.createdAt = Date()
        self.updateAt = Date()
    }
    
    var isValid: Bool {
        return !businessName.trimmingCharacters(in: .whitespaces).isEmpty && !businessPhoneNum.trimmingCharacters(in: .whitespaces).isEmpty && !businessEmail.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

