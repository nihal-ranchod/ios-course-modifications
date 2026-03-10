//
//  AccountDetailViewController.swift
//  Bankey
//

import UIKit

final class AccountDetailViewController: UIViewController {

    let account: Account
    let transactions: [Transaction]

    // MARK: - Header UI
    let accountNameLabel = UILabel()
    let accountTypeLabel = UILabel()
    let underlineView = UIView()
    let balanceTitleLabel = UILabel()
    let balanceAmountLabel = UILabel()
    let openedDateLabel = UILabel()

    // MARK: - Table
    let tableView = UITableView()

    static let transactionCellID = "TransactionCell"

    // MARK: - Init

    init(account: Account) {
        self.account = account
        self.transactions = AccountDetailData.transactions(forAccountId: account.id)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = account.name
        setupHeader()
        setupTableView()
    }
}

// MARK: - Setup
extension AccountDetailViewController {

    private func setupHeader() {
        // Account type label
        accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        accountTypeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        accountTypeLabel.text = account.type.rawValue

        // Underline — color coded by account type
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        switch account.type {
        case .Banking:
            underlineView.backgroundColor = appColor
        case .CreditCard:
            underlineView.backgroundColor = .systemOrange
        case .Investment:
            underlineView.backgroundColor = .systemPurple
        }

        // Account name
        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        accountNameLabel.text = account.name

        // Balance title
        balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        balanceTitleLabel.textColor = .secondaryLabel
        switch account.type {
        case .Banking:
            balanceTitleLabel.text = "Current balance"
        case .CreditCard:
            balanceTitleLabel.text = "Balance"
        case .Investment:
            balanceTitleLabel.text = "Value"
        }

        // Balance amount — uses the existing CurrencyFormatter
        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceAmountLabel.attributedText = CurrencyFormatter().makeAttributedCurrency(account.amount)

        // Opened date
        openedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        openedDateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        openedDateLabel.textColor = .secondaryLabel
        openedDateLabel.text = "Opened: \(account.createdDateTime.monthDayYearString)"

        // Add to view
        view.addSubview(accountTypeLabel)
        view.addSubview(underlineView)
        view.addSubview(accountNameLabel)
        view.addSubview(balanceTitleLabel)
        view.addSubview(balanceAmountLabel)
        view.addSubview(openedDateLabel)

        NSLayoutConstraint.activate([
            // Account type
            accountTypeLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            accountTypeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            // Underline
            underlineView.topAnchor.constraint(equalToSystemSpacingBelow: accountTypeLabel.bottomAnchor, multiplier: 1),
            underlineView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            underlineView.widthAnchor.constraint(equalToConstant: 60),
            underlineView.heightAnchor.constraint(equalToConstant: 4),

            // Account name
            accountNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
            accountNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            // Balance title
            balanceTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: accountNameLabel.bottomAnchor, multiplier: 2),
            balanceTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            // Balance amount
            balanceAmountLabel.topAnchor.constraint(equalToSystemSpacingBelow: balanceTitleLabel.bottomAnchor, multiplier: 1),
            balanceAmountLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            // Opened date
            openedDateLabel.topAnchor.constraint(equalToSystemSpacingBelow: balanceAmountLabel.bottomAnchor, multiplier: 2),
            openedDateLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AccountDetailViewController.transactionCellID)
        tableView.rowHeight = 56

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: openedDateLabel.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension AccountDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Transactions"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailViewController.transactionCellID, for: indexPath)
        let transaction = transactions[indexPath.row]

        // Configure cell with transaction data
        var content = cell.defaultContentConfiguration()
        content.text = transaction.description
        content.secondaryText = transaction.date.monthDayYearString

        cell.contentConfiguration = content

        // Amount label on the right side
        let amountLabel = UILabel()
        amountLabel.font = UIFont.preferredFont(forTextStyle: .body)

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        let amountString = formatter.string(from: transaction.amount as NSDecimalNumber) ?? "$0.00"

        if transaction.isCredit {
            amountLabel.text = "+\(amountString)"
            amountLabel.textColor = .systemGreen
        } else {
            amountLabel.text = "-\(amountString)"
            amountLabel.textColor = .systemRed
        }

        amountLabel.sizeToFit()
        cell.accessoryView = amountLabel
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: - UITableViewDelegate
extension AccountDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
