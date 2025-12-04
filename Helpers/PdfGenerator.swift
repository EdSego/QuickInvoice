//
//  PDFGenerator.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 12/2/25.
//

import UIKit
import PDFKit

class PDFGenerator {
    
    /// Generates a professional invoice PDF
    static func generateInvoicePDF(
        invoice: Invoice,
        businessInfo: BusinessInfo? = nil
    ) -> Data? {
        
        // Create PDF metadata
        let pdfMetaData: [CFString: Any] = [
            kCGPDFContextCreator: "QuickInvoice",
            kCGPDFContextAuthor: businessInfo?.businessName ?? "Invoice",
            kCGPDFContextTitle: "Invoice-\(invoice.invoiceNumber)"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Standard US Letter size (8.5 x 11 inches at 72 DPI)
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Draw the invoice content
            drawInvoice(
                invoice: invoice,
                businessInfo: businessInfo,
                in: pageRect,
                context: context.cgContext
            )
        }
        
        return data
    }
    
    // MARK: - Main Layout
    
    private static func drawInvoice(
        invoice: Invoice,
        businessInfo: BusinessInfo?,
        in pageRect: CGRect,
        context: CGContext
    ) {
        let margin: CGFloat = 40
        var yPosition: CGFloat = margin
        
        // 1. Header (business info or generic title)
        yPosition = drawHeader(
            businessInfo: businessInfo,
            yPosition: yPosition,
            pageWidth: pageRect.width,
            margin: margin,
            context: context
        )
        
        yPosition += 20
        
        // 2. Invoice title and number
        yPosition = drawInvoiceTitle(
            invoice: invoice,
            yPosition: yPosition,
            pageWidth: pageRect.width,
            margin: margin,
            context: context
        )
        
        yPosition += 30
        
        // 3. Invoice info (date, job number)
        yPosition = drawInvoiceInfo(
            invoice: invoice,
            yPosition: yPosition,
            pageWidth: pageRect.width,
            margin: margin,
            context: context
        )
        
        yPosition += 30
        
        // 4. Client information
        yPosition = drawClientInfo(
            client: invoice.client,
            yPosition: yPosition,
            margin: margin,
            context: context
        )
        
        yPosition += 30
        
        // 5. Line items table
        yPosition = drawLineItemsTable(
            lineItems: invoice.lineItems,
            yPosition: yPosition,
            pageWidth: pageRect.width,
            margin: margin,
            context: context
        )
        
        yPosition += 20
        
        // 6. Total amount
        yPosition = drawTotal(
            total: invoice.totalAmount,
            yPosition: yPosition,
            pageWidth: pageRect.width,
            margin: margin,
            context: context
        )
        
        // 7. Footer
        drawFooter(
            pageRect: pageRect,
            margin: margin,
            context: context
        )
    }
    
    // MARK: - Header Section
    
    private static func drawHeader(
        businessInfo: BusinessInfo?,
        yPosition: CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat,
        context: CGContext
    ) -> CGFloat {
        var y = yPosition
        
        if let business = businessInfo {
            // Business Name (large, bold)
            let nameFont = UIFont.boldSystemFont(ofSize: 22)
            let nameRect = CGRect(
                x: margin,
                y: y,
                width: pageWidth - 2 * margin,
                height: 30
            )
            drawText(
                business.businessName,
                in: nameRect,
                font: nameFont,
                alignment: .left,
                context: context
            )
            y += 28
            
            let infoFont = UIFont.systemFont(ofSize: 10)
            
            // Phone
            let phoneRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 15)
            drawText(
                "Phone: \(business.businessPhoneNum)",
                in: phoneRect,
                font: infoFont,
                alignment: .left,
                context: context
            )
            y += 13
            
            // Email
            let emailRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 15)
            drawText(
                "Email: \(business.businessEmail)",
                in: emailRect,
                font: infoFont,
                alignment: .left,
                context: context
            )
            y += 13
            
            // Address (if present)
            if let address = business.businessAddress, !address.isEmpty {
                let addressRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 15)
                drawText(
                    address,
                    in: addressRect,
                    font: infoFont,
                    alignment: .left,
                    context: context
                )
                y += 13
            }
            
            // State and Zip (if present)
            if let state = business.businessState, let zip = business.businessZipCode,
               !state.isEmpty || !zip.isEmpty {
                let location = [state, zip].filter { !$0.isEmpty }.joined(separator: " ")
                let locationRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 15)
                drawText(
                    location,
                    in: locationRect,
                    font: infoFont,
                    alignment: .left,
                    context: context
                )
                y += 13
            }
            
            // License Number (if present)
            if let license = business.businessLicNum, !license.isEmpty {
                let licenseRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 15)
                drawText(
                    "License #: \(license)",
                    in: licenseRect,
                    font: infoFont,
                    alignment: .left,
                    context: context
                )
                y += 13
            }
        } else {
            // Fallback: Simple "INVOICE" header
            let titleFont = UIFont.boldSystemFont(ofSize: 22)
            let titleRect = CGRect(
                x: margin,
                y: y,
                width: pageWidth - 2 * margin,
                height: 30
            )
            drawText(
                "INVOICE",
                in: titleRect,
                font: titleFont,
                alignment: .left,
                context: context
            )
            y += 28
        }
        
        // Separator line
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: margin, y: y))
        context.addLine(to: CGPoint(x: pageWidth - margin, y: y))
        context.strokePath()
        y += 5
        
        return y
    }
    
    // MARK: - Invoice Title
    
    private static func drawInvoiceTitle(
        invoice: Invoice,
        yPosition: CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat,
        context: CGContext
    ) -> CGFloat {
        var y = yPosition
        
        // "INVOICE" title on the left
        let titleFont = UIFont.boldSystemFont(ofSize: 26)
        let titleRect = CGRect(x: margin, y: y, width: 200, height: 30)
        drawText(
            "INVOICE",
            in: titleRect,
            font: titleFont,
            alignment: .left,
            context: context
        )
        
        // Invoice number on the right
        let numberFont = UIFont.systemFont(ofSize: 14)
        let numberRect = CGRect(
            x: pageWidth - margin - 150,
            y: y + 8,
            width: 150,
            height: 20
        )
        drawText(
            invoice.invoiceNumber,
            in: numberRect,
            font: numberFont,
            alignment: .right,
            context: context
        )
        
        y += 30
        return y
    }
    
    // MARK: - Invoice Info (Date, Job #)
    
    private static func drawInvoiceInfo(
        invoice: Invoice,
        yPosition: CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat,
        context: CGContext
    ) -> CGFloat {
        var y = yPosition
        
        let labelFont = UIFont.boldSystemFont(ofSize: 10)
        let valueFont = UIFont.systemFont(ofSize: 10)
        
        // Date
        let dateLabelRect = CGRect(x: margin, y: y, width: 100, height: 15)
        drawText("Date:", in: dateLabelRect, font: labelFont, alignment: .left, context: context)
        
        let dateValueRect = CGRect(x: margin + 50, y: y, width: 150, height: 15)
        drawText(
            invoice.formattedDate,
            in: dateValueRect,
            font: valueFont,
            alignment: .left,
            context: context
        )
        y += 15
        
        // Job Number (if present)
        if let jobNum = invoice.jobNumber, !jobNum.isEmpty {
            let jobLabelRect = CGRect(x: margin, y: y, width: 100, height: 15)
            drawText("Job #:", in: jobLabelRect, font: labelFont, alignment: .left, context: context)
            
            let jobValueRect = CGRect(x: margin + 50, y: y, width: 150, height: 15)
            drawText(jobNum, in: jobValueRect, font: valueFont, alignment: .left, context: context)
            y += 15
        }
        
        return y
    }
    
    // MARK: - Client Info
    
    private static func drawClientInfo(
        client: Client?,
        yPosition: CGFloat,
        margin: CGFloat,
        context: CGContext
    ) -> CGFloat {
        var y = yPosition
        
        guard let client = client else { return y }
        
        // "Bill To:" label
        let labelFont = UIFont.boldSystemFont(ofSize: 11)
        let labelRect = CGRect(x: margin, y: y, width: 100, height: 15)
        drawText("BILL TO:", in: labelRect, font: labelFont, alignment: .left, context: context)
        y += 18
        
        let detailFont = UIFont.systemFont(ofSize: 10)
        
        // Client Name (bold)
        let nameRect = CGRect(x: margin, y: y, width: 300, height: 15)
        drawText(
            client.clientName,
            in: nameRect,
            font: UIFont.boldSystemFont(ofSize: 10),
            alignment: .left,
            context: context
        )
        y += 15
        
        // Phone
        let phoneRect = CGRect(x: margin, y: y, width: 300, height: 15)
        drawText(
            client.clientPhoneNum,
            in: phoneRect,
            font: detailFont,
            alignment: .left,
            context: context
        )
        y += 15
        
        // Email (if present)
        if let email = client.clientEmail, !email.isEmpty {
            let emailRect = CGRect(x: margin, y: y, width: 300, height: 15)
            drawText(email, in: emailRect, font: detailFont, alignment: .left, context: context)
            y += 15
        }
        
        // Address (if present)
        if let address = client.clientAddress, !address.isEmpty {
            let addressRect = CGRect(x: margin, y: y, width: 300, height: 15)
            drawText(address, in: addressRect, font: detailFont, alignment: .left, context: context)
            y += 15
        }
        
        return y
    }
    
    // MARK: - Line Items Table
    
    private static func drawLineItemsTable(
        lineItems: [LineItem],
        yPosition: CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat,
        context: CGContext
    ) -> CGFloat {
        var y = yPosition
        
        let tableWidth = pageWidth - 2 * margin
        let col1Width = tableWidth * 0.10  // Item #
        let col2Width = tableWidth * 0.50  // Description
        let col3Width = tableWidth * 0.40  // Amount
        
        // TABLE HEADER
        context.setFillColor(UIColor.systemBlue.cgColor)
        let headerRect = CGRect(x: margin, y: y, width: tableWidth, height: 25)
        context.fill(headerRect)
        
        let headerFont = UIFont.boldSystemFont(ofSize: 11)
        context.setFillColor(UIColor.white.cgColor)
        
        var headerX = margin + 5
        
        // "Item" header
        let itemHeaderRect = CGRect(x: headerX, y: y + 6, width: col1Width - 5, height: 15)
        drawText("Item", in: itemHeaderRect, font: headerFont, alignment: .left, context: context)
        
        // "Description" header
        headerX += col1Width
        let descHeaderRect = CGRect(x: headerX, y: y + 6, width: col2Width - 5, height: 15)
        drawText("Description", in: descHeaderRect, font: headerFont, alignment: .left, context: context)
        
        // "Amount" header
        headerX += col2Width
        let amountHeaderRect = CGRect(x: headerX, y: y + 6, width: col3Width - 10, height: 15)
        drawText("Amount", in: amountHeaderRect, font: headerFont, alignment: .right, context: context)
        
        y += 25
        
        // TABLE ROWS
        let itemFont = UIFont.systemFont(ofSize: 10)
        context.setFillColor(UIColor.black.cgColor)
        
        for (index, item) in lineItems.enumerated() {
            let hasDescription = !(item.itemDescription?.isEmpty ?? true)
            let rowHeight: CGFloat = hasDescription ? 40 : 25
            
            // Alternating row background
            if index % 2 == 0 {
                context.setFillColor(UIColor.systemGray6.cgColor)
                let rowRect = CGRect(x: margin, y: y, width: tableWidth, height: rowHeight)
                context.fill(rowRect)
                context.setFillColor(UIColor.black.cgColor)
            }
            
            var itemX = margin + 5
            
            // Item number
            let itemNumRect = CGRect(x: itemX, y: y + 6, width: col1Width - 5, height: 15)
            drawText("\(index + 1)", in: itemNumRect, font: itemFont, alignment: .left, context: context)
            
            // Item name (bold)
            itemX += col1Width
            let nameRect = CGRect(x: itemX, y: y + 6, width: col2Width - 5, height: 15)
            drawText(
                item.itemName,
                in: nameRect,
                font: UIFont.boldSystemFont(ofSize: 10),
                alignment: .left,
                context: context
            )
            
            // Description (if present)
            if let description = item.itemDescription, !description.isEmpty {
                let descRect = CGRect(x: itemX, y: y + 20, width: col2Width - 5, height: 15)
                drawText(
                    description,
                    in: descRect,
                    font: UIFont.systemFont(ofSize: 9),
                    alignment: .left,
                    context: context
                )
            }
            
            // Amount
            itemX += col2Width
            let amountRect = CGRect(x: itemX, y: y + 6, width: col3Width - 10, height: 15)
            drawText(
                item.formattedPrice,
                in: amountRect,
                font: itemFont,
                alignment: .right,
                context: context
            )
            
            y += rowHeight
        }
        
        // Table border
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        context.stroke(
            CGRect(
                x: margin,
                y: yPosition,
                width: tableWidth,
                height: y - yPosition
            )
        )
        
        return y
    }
    
    // MARK: - Total Box
    
    private static func drawTotal(
        total: Double,
        yPosition: CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat,
        context: CGContext
    ) -> CGFloat {
        var y = yPosition
        
        let boxWidth: CGFloat = 200
        let boxHeight: CGFloat = 40
        let boxX = pageWidth - margin - boxWidth
        
        // Background with light blue tint
        context.setFillColor(UIColor.systemBlue.withAlphaComponent(0.1).cgColor)
        let boxRect = CGRect(x: boxX, y: y, width: boxWidth, height: boxHeight)
        context.fill(boxRect)
        
        // Border
        context.setStrokeColor(UIColor.systemBlue.cgColor)
        context.setLineWidth(2)
        context.stroke(boxRect)
        
        // "TOTAL:" label
        let labelFont = UIFont.boldSystemFont(ofSize: 14)
        let labelRect = CGRect(x: boxX + 10, y: y + 10, width: 80, height: 20)
        drawText("TOTAL:", in: labelRect, font: labelFont, alignment: .left, context: context)
        
        // Amount
        let amountFont = UIFont.boldSystemFont(ofSize: 16)
        let formattedTotal = String(format: "$%.2f", total)
        let amountRect = CGRect(x: boxX + 90, y: y + 10, width: 100, height: 20)
        drawText(formattedTotal, in: amountRect, font: amountFont, alignment: .right, context: context)
        
        y += boxHeight
        return y
    }
    
    // MARK: - Footer
    
    private static func drawFooter(
        pageRect: CGRect,
        margin: CGFloat,
        context: CGContext
    ) {
        let footerFont = UIFont.systemFont(ofSize: 10)
        let footerText = "Thank you for your business!"
        let footerRect = CGRect(
            x: margin,
            y: pageRect.height - margin - 20,
            width: pageRect.width - 2 * margin,
            height: 20
        )
        
        drawText(footerText, in: footerRect, font: footerFont, alignment: .center, context: context)
    }
    
    // MARK: - Text Drawing Helper
    
    private static func drawText(
        _ text: String,
        in rect: CGRect,
        font: UIFont,
        alignment: NSTextAlignment,
        context: CGContext
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.black
        ]
        
        (text as NSString).draw(in: rect, withAttributes: attributes)
    }
}//
//  PdvGenerator.swift
//  QuickInvoice
//
//  Created by Bryan Alarcon on 12/3/25.
//

