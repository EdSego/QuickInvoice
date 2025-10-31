//
//  PersonInfo.swift
//
// QuickInvoice
//
//  Created by Bryan Alarcon on 10/31/25.
//

import Foundation
import SwiftData

@Model
final class PersonInfo{

    var personName: String
    
    var personPhoneNum: String
    
    var personEmail: String?
    
    var createdAt: Date
    var updateAt: Date
    
    init (
        personName: String = "",
        personPhoneNum: String = "",
        personEmail: String? = nil,
    ){
        self.personName = personName
        self.personPhoneNum = personPhoneNum
        self.personEmail = personEmail
        self.createdAt = Date()
        self.updateAt = Date()
    }
    
    var isValid: Bool {
        return !personName.trimmingCharacters(in: .whitespaces).isEmpty && !personPhoneNum.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

