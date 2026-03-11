//
//  AccountDetailViewModel.swift
//  Bankey
//

import UIKit

final class AccountDetailViewModel {

    private let account: Account
    private let transactions: [Transaction]

    init(account: Account) {
        self.account = account
        self.transactions = AccountDetailData.transactions(forAccountId: account.id)
    }

    // MARK: - Header Data

    var accountName: String { account.name }
    var accountType: String { account.type.rawValue }

    var underlineColor: UIColor {
        switch account.type {
        case .Banking:    return appColor
        case .CreditCard: return .systemOrange
        case .Investment: return .systemPurple
        }
    }

    var balanceTitle: String {
        switch account.type {
        case .Banking:    return "Current balance"
        case .CreditCard: return "Balance"
        case .Investment: return "Value"
        }
    }

    var balanceAmount: NSAttributedString {
        CurrencyFormatter().makeAttributedCurrency(account.amount)
    }

    var openedDate: String {
        "Opened: \(account.createdDateTime.monthDayYearString)"
    }

    // MARK: - Transaction Data

    var transactionCount: Int { transactions.count }

    func transaction(at index: Int) -> Transaction {
        transactions[index]
    }

    func formattedAmount(for transaction: Transaction) -> (text: String, color: UIColor) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        let amount = formatter.string(from: transaction.amount as NSDecimalNumber) ?? "$0.00"

        if transaction.isCredit {
            return ("+\(amount)", .systemGreen)
        } else {
            return ("-\(amount)", .systemRed)
        }
    }
}
