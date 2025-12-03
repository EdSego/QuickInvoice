//
//  PersonalInfoVIewModel.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/3/25.
//

import Foundation
import SwiftUI
import SwiftData

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
    
    //Creating a person object
    private var personInfo: PersonInfo?
   
    //initializing - let the create object = personInfo
    init(personInfo: PersonInfo? = nil){
        self.personInfo = personInfo
        
        if let personInfo {
            personalName = personInfo.personName
            phone = personInfo.personPhoneNum
            email = personInfo.personEmail ?? ""
        }
    }
    
    
    var isValid: Bool {
        !personalName.isBlank &&
        !phone.isBlank &&
        email.isValidEmail
    }
    
    /// Called from the view when we find an existing PersonInfo in SwiftData
        func load(from entity: PersonInfo) {
            // Avoid reloading if we already attached this one
            guard personInfo == nil else { return }
            
            personInfo   = entity
            personalName = entity.personName
            phone        = entity.personPhoneNum
            email        = entity.personEmail ?? ""
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
    
    func save(focus: inout ProfileField?, context: ModelContext) {
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
        
        let entity: PersonInfo
        
        if let existing = personInfo {
            entity = existing //editing
        } else {
            entity = PersonInfo() //Create a new instance
            context.insert(entity)
            personInfo = entity
        }
        
        entity.personName = personalName
        entity.personPhoneNum = phone
        entity.personEmail = email
        entity.updateAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save PersonInfo: \(error)")
        }
    }
    
}
