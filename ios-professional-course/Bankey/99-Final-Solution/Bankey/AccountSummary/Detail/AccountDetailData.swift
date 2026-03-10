//
//  AccountDetailData.swift
//  Bankey
//

import Foundation

struct Transaction {
    let date: Date
    let description: String
    let amount: Decimal
    let isCredit: Bool // true = money in, false = money out
}

struct AccountDetailData {

    // Returns mock transactions for a given account ID
    static func transactions(forAccountId id: String) -> [Transaction] {
        let calendar = Calendar.current
        let now = Date()

        switch id {
        case "1": // Basic Savings
            return [
                Transaction(date: calendar.date(byAdding: .day, value: -1, to: now)!,
                            description: "Payroll Deposit",
                            amount: 3250.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -3, to: now)!,
                            description: "ATM Withdrawal",
                            amount: 200.00, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -5, to: now)!,
                            description: "Transfer to Chequing",
                            amount: 500.00, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -12, to: now)!,
                            description: "Interest Payment",
                            amount: 12.45, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -15, to: now)!,
                            description: "Payroll Deposit",
                            amount: 3250.00, isCredit: true),
            ]
        case "2": // No-Fee All-In Chequing
            return [
                Transaction(date: calendar.date(byAdding: .day, value: -1, to: now)!,
                            description: "Grocery Store",
                            amount: 87.32, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -2, to: now)!,
                            description: "Transfer from Savings",
                            amount: 500.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -4, to: now)!,
                            description: "Electric Bill",
                            amount: 142.50, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -7, to: now)!,
                            description: "Gas Station",
                            amount: 55.00, isCredit: false),
            ]
        case "3": // Visa Avion Card
            return [
                Transaction(date: calendar.date(byAdding: .day, value: -1, to: now)!,
                            description: "Amazon.ca",
                            amount: 49.99, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -3, to: now)!,
                            description: "Restaurant - The Keg",
                            amount: 86.40, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -5, to: now)!,
                            description: "Payment - Thank You",
                            amount: 200.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -8, to: now)!,
                            description: "Netflix Subscription",
                            amount: 16.99, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -10, to: now)!,
                            description: "Uber Ride",
                            amount: 23.45, isCredit: false),
            ]
        case "4": // Student Mastercard
            return [
                Transaction(date: calendar.date(byAdding: .day, value: -2, to: now)!,
                            description: "Textbook - Campus Store",
                            amount: 35.00, isCredit: false),
                Transaction(date: calendar.date(byAdding: .day, value: -6, to: now)!,
                            description: "Payment - Thank You",
                            amount: 50.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -9, to: now)!,
                            description: "Coffee Shop",
                            amount: 5.83, isCredit: false),
            ]
        case "5": // Tax-Free Saver
            return [
                Transaction(date: calendar.date(byAdding: .day, value: -7, to: now)!,
                            description: "Monthly Contribution",
                            amount: 250.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -30, to: now)!,
                            description: "Interest Payment",
                            amount: 8.33, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -37, to: now)!,
                            description: "Monthly Contribution",
                            amount: 250.00, isCredit: true),
            ]
        case "6": // Growth Fund
            return [
                Transaction(date: calendar.date(byAdding: .day, value: -5, to: now)!,
                            description: "Dividend Payment",
                            amount: 125.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -14, to: now)!,
                            description: "Additional Investment",
                            amount: 1000.00, isCredit: true),
                Transaction(date: calendar.date(byAdding: .day, value: -30, to: now)!,
                            description: "Management Fee",
                            amount: 15.00, isCredit: false),
            ]
        default:
            return []
        }
    }
}
