//
//  LineItem.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 10/31/25.
//

import Foundation
import SwiftData

@Model
final class LineItem{

    var itemName: String

    var itemPriceCents: Int
    
    var itemDescription: String?
    
    var sortOrder: Int
    
    var createdAt: Date
    
    @Relationship(inverse: \Invoice.lineItems)
    var invoice: Invoice?
    
    var itemPrice: Double {
        Double(itemPriceCents) / 100
    }
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: itemPrice)) ?? "$0.00"
    }
    
    init (
        itemName: String = "",
        itemPriceCents: Int = 0,
        itemDescription: String? = nil,
        sortOrder: Int = 0
    ){
        self.itemName = itemName
        self.itemPriceCents = itemPriceCents
        self.itemDescription = itemDescription
        self.sortOrder = sortOrder
        self.createdAt = Date()
    }
    
    
    convenience init(
        itemName: String,
        itemPrice: Double,
        itemDescription: String? = nil,
        sortOrder: Int = 0
    ) {
        let cents = Int(round(itemPrice*100))
        self.init(
            itemName: itemName,
            itemPriceCents: cents,
            itemDescription: itemDescription,
            sortOrder: sortOrder
        )
    }
        
    
    
    var isValid: Bool {
        return !itemName.trimmingCharacters(in: .whitespaces).isEmpty && itemPriceCents > 0
    }
}


