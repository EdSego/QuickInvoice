# QuickInvoice — CPSC 411 Mobile Development Project

**Course:** CPSC 411 – Mobile Development  
**Developers:** Bryan Alarcon & Edwin Segovia  
**Project Type:** iOS Application  
**Language:** Swift / SwiftUI  
---

## Project Overview
QuickInvoice is an iOS application designed to help **contractors and tradesmen**—especially those less familiar with technology—create and share invoices effortlessly.  
The goal is to simplify the invoice creation process by providing an **intuitive, minimal-friction UI** with the ability to **export invoices as PDFs** directly from the app.

---

## Core Features
- **Invoice Creation:** Input key details such as client name, date, work description, and payment total.  
- **PDF Generation:** Automatically format and export invoices to share via text or email.  
- **Invoice Log:** View previously created invoices stored locally for reference and tracking.  
- **User-Friendly Design:** Minimal clutter, large touch targets, and clear text fields aimed at older or non-technical users.  

---

## Tech Stack
| Layer | Tool / Framework |
|-------|------------------|
| Language | **Swift (SwiftUI)** |
| IDE | **Xcode 15+** |
| Platform | **iOS 17** |
| File Handling | **PDFKit** |
| Version Control | **Git & GitHub** |

---

## Architecture
The app follows a **Model–View–ViewModel (MVVM)** pattern to separate logic and UI presentation:
- **Models:** Represent invoice data and formatting.  
- **ViewModels:** Handle user input, validation, and PDF generation.  
- **Views:** SwiftUI components for invoice forms and lists.

---

## How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/EdSego/QuickInvoice.git
2. Open the project in Xcode:
   ```bash
   open QuickInvoice.xcodeproj
3. Choose an iPhone simulator or connected device.
4. Press Run ▶️ to build and launch the app.



## Contributors
| Name              | Role      | GitHub                                             |
| ----------------- | --------- | -------------------------------------------------- |
| **Bryan Alarcon** | Developer | [@bryanalarconn](https://github.com/bryanalarconn) |
| **Edwin Segovia** | Developer | [@edsego](https://github.com/edsego)               |
