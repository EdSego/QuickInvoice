//
//  BusinessInfoViewModel.swift
//  QuickInvoice
//
//  Created by Edwin Segovia on 11/17/25.
//

import Foundation
import SwiftUI


@MainActor
final class BusinessInfoViewModel: ObservableObject {
    
    @Published var businessName: String = ""
    
    @Published var businessPhoneNum: String = ""
    
    @Published var businessEmail: String = ""
    
    @Published var businessAddress: String? = ""
    
    @Published var businessState: String? = ""
    
    @Published var businessZipCode: String? = ""
    
    @Published var businessLicNum: String? = ""
    
    
    
    
}
