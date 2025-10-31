//
//  Client.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 10/31/25.
//

import Foundation
import SwiftData

@Model
final class Client{

    var clientName: String
    
    var clientPhoneNum: String
    
    var clientEmail: String?
    
    var clientAddress: String?
    
    var createdAt: Date

    init (
        clientName: String = "",
        clientPhoneNum: String = "",
        clientEmail: String? = nil,
        clientAddress: String? = nil,
    ){
        self.clientName = clientName
        self.clientPhoneNum = clientPhoneNum
        self.clientEmail = clientEmail
        self.clientAddress = clientAddress
        self.createdAt = Date()
    }
    
    var isValid: Bool {
        return !clientName.trimmingCharacters(in: .whitespaces).isEmpty && !clientPhoneNum.trimmingCharacters(in: .whitespaces).isEmpty 
    }
}

