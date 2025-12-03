//
//  PersonalInfoVIewModel.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/3/25.
//

import Foundation
import SwiftUI

enum ProfileField: CaseIterable, Hashable {
    case name, phone, email
}

@MainActor
final class PersonalInfoViewModel: ObservableObject {
    
    @Published var personalName = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var submitted = false
    
    
    // Validation state
       @Published var errors: [ProfileField: String] = [:]
       @Published var touched: Set<ProfileField> = []
    
    var isValid: Bool {
        !personalName.isBlank &&
        !phone.isBlank &&
        email.isValidEmail
    }
    
    func validate(_ field: ProfileField) {
        switch field {
        case .name:
            errors[.name] = personalName.isBlank ? "Name is required" : nil

        case .phone:
            errors[.phone] = phone.isBlank ? "Phone is required" : nil
            // You can add format checks here if needed.

        case .email:
            if email.isBlank { errors[.email] = "Email is required" }
            else if !email.isValidEmail { errors[.email] = "Enter a valid email address" }
            else { errors[.email] = nil }
        }
    }

    func shouldShow(_ field: ProfileField) -> Bool{
        (touched.contains(field) || submitted && errors[field] != nil)
    }
    
    
    /// Validate everything at once (e.g., when tapping Save)
    @discardableResult
    func validateAll() -> Bool {
        ProfileField.allCases.forEach { validate($0) }
        return isValid
    }
    
    func resetValidation(){
        errors.removeAll()
        touched.removeAll()
    }

    func markTouched(_ field: ProfileField) {
        touched.insert(field)
    }
    
    func save(focus: inout ProfileField?) {
        //        guard validateAll() else {
        //            print("Invalid input - not saved.")
        //            touched = Set(ProfileField.allCases)
        //            return
        //        }
        //        print("Saving info!")
        submitted = true
        guard validateAll() else {
            touched = Set(ProfileField.allCases)
            focus = ProfileField.allCases.first { errors[$0] != nil } // jump to first invalid
            return
        }
        
        
    }
    
}
