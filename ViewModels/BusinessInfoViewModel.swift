//
//  BusinessInfoViewModel.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/17/25.
//

import Foundation
import SwiftUI
import SwiftData


@MainActor
final class BusinessInfoViewModel: ObservableObject {
    
    @Published var businessName: String = ""
    
    @Published var businessPhoneNum: String = ""
    
    @Published var businessEmail: String = ""
    
    @Published var businessAddress: String? = ""
    
    @Published var businessState: String? = ""
    
    @Published var businessZipCode: String? = ""
    
    @Published var businessLicNum: String? = ""
    
    
    private var businessInfo:BusinessInfo?
    
    init(businessInfo: BusinessInfo? = nil){
        self.businessInfo = businessInfo
        
        if let info = businessInfo {
            businessName = info.businessName
            businessPhoneNum = info.businessPhoneNum
            businessEmail = info.businessEmail
            businessAddress = info.businessAddress
            businessLicNum = info.businessLicNum
            businessState = info.businessState
            businessZipCode = info.businessZipCode
        }
    }
    
    var isValid: Bool {
        !businessName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !businessPhoneNum.trimmingCharacters(in: .whitespaces).isEmpty &&
        !businessEmail.isValidEmail.description.isEmpty
    }
    
    /// Load data from an existing BusinessInfo (called from the view)
    func load(from entity: BusinessInfo) {
        // Avoid re-binding if we're already working with one
        guard businessInfo == nil || businessInfo !== entity else { return }
        
        businessInfo      = entity
        businessName      = entity.businessName
        businessPhoneNum  = entity.businessPhoneNum
        businessEmail     = entity.businessEmail
        businessAddress   = entity.businessAddress
        businessLicNum    = entity.businessLicNum
    }
    
    
    /// Save changes to SwiftData
    func save(context: ModelContext) {
        guard isValid else {
            // You could later hook this up to error UI if you want
            print("Business info not valid, not saving")
            return
        }
        
        let entity: BusinessInfo
        
        if let existing = businessInfo {
            entity = existing   // update existing row
        } else {
            entity = BusinessInfo()
            context.insert(entity)
            businessInfo = entity
        }
        
        entity.businessName     = businessName
        entity.businessPhoneNum = businessPhoneNum
        entity.businessEmail    = businessEmail
        entity.businessAddress  = businessAddress
        entity.businessLicNum   = businessLicNum
        entity.updateAt         = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save BusinessInfo: \(error)")
        }
    }
    
    
}
