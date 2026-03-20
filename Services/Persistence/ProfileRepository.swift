//
//  ProfileRepository.swift
//  QuickInvoice
//
//  Created by Codex on 3/12/26.
//

import Foundation
import SwiftData

@MainActor
final class ProfileRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func loadPersonalInfo() throws -> PersonInfo? {
        var descriptor = FetchDescriptor<PersonInfo>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func savePersonalInfo(
        name: String,
        phone: String,
        email: String
    ) throws -> PersonInfo {
        let entity = try loadPersonalInfo() ?? {
            let person = PersonInfo()
            modelContext.insert(person)
            return person
        }()

        entity.personName = name
        entity.personPhoneNum = phone
        entity.personEmail = email.isEmpty ? nil : email
        entity.updateAt = Date()

        try modelContext.save()
        return entity
    }

    func loadBusinessInfo() throws -> BusinessInfo? {
        var descriptor = FetchDescriptor<BusinessInfo>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func saveBusinessInfo(
        name: String,
        phone: String,
        email: String,
        address: String?,
        state: String?,
        zipCode: String?,
        licenseNumber: String?
    ) throws -> BusinessInfo {
        let entity = try loadBusinessInfo() ?? {
            let business = BusinessInfo()
            modelContext.insert(business)
            return business
        }()

        entity.businessName = name
        entity.businessPhoneNum = phone
        entity.businessEmail = email
        entity.businessAddress = emptyToNil(address)
        entity.businessState = emptyToNil(state)
        entity.businessZipCode = emptyToNil(zipCode)
        entity.businessLicNum = emptyToNil(licenseNumber)
        entity.updateAt = Date()

        try modelContext.save()
        return entity
    }

    private func emptyToNil(_ value: String?) -> String? {
        guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty else {
            return nil
        }
        return trimmed
    }
}
