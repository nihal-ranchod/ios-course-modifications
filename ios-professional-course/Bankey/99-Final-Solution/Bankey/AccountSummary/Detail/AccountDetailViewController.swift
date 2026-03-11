//
//  AccountDetailViewController.swift
//  Bankey
//

import UIKit

final class AccountDetailViewController: UIViewController {

    // ViewModel
    private var viewModel: AccountDetailViewModel

    // MARK: - Header UI
    private lazy var accountNameLabel = UILabel()
    private lazy var accountTypeLabel = UILabel()
    private lazy var underlineView = UIView()
    private lazy var balanceTitleLabel = UILabel()
    private lazy var balanceAmountLabel = UILabel()
    private lazy var openedDateLabel = UILabel()

    // MARK: - Table
    private lazy var tableView = UITableView()

    static let transactionCellID = "TransactionCell"

    // MARK: - Init

    init(account: Account) {
        self.viewModel = AccountDetailViewModel(account: account)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.accountName
        setupHeader()
        setupTableView()
    }
}

// MARK: - Setup
extension AccountDetailViewController {

    private func setupHeader() {
        accountTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        accountTypeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        accountTypeLabel.text = viewModel.accountType

        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = viewModel.underlineColor

        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        accountNameLabel.text = viewModel.accountName

        balanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceTitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        balanceTitleLabel.textColor = .secondaryLabel
        balanceTitleLabel.text = viewModel.balanceTitle

        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceAmountLabel.attributedText = viewModel.balanceAmount

        openedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        openedDateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        openedDateLabel.textColor = .secondaryLabel
        openedDateLabel.text = viewModel.openedDate

        view.addSubview(accountTypeLabel)
        view.addSubview(underlineView)
        view.addSubview(accountNameLabel)
        view.addSubview(balanceTitleLabel)
        view.addSubview(balanceAmountLabel)
        view.addSubview(openedDateLabel)

        NSLayoutConstraint.activate([
            accountTypeLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            accountTypeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            underlineView.topAnchor.constraint(equalToSystemSpacingBelow: accountTypeLabel.bottomAnchor, multiplier: 1),
            underlineView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            underlineView.widthAnchor.constraint(equalToConstant: 60),
            underlineView.heightAnchor.constraint(equalToConstant: 4),

            accountNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
            accountNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            balanceTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: accountNameLabel.bottomAnchor, multiplier: 2),
            balanceTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

            balanceAmountLabel.topAnchor.constraint(equalToSystemSpacingBelow: balanceTitleLabel.bottomAnchor, multiplier: 1),
            balanceAmountLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),

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
        return viewModel.transactionCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailViewController.transactionCellID, for: indexPath)
        let transaction = viewModel.transaction(at: indexPath.row)

        var content = cell.defaultContentConfiguration()
        content.text = transaction.description
        content.secondaryText = transaction.date.monthDayYearString
        cell.contentConfiguration = content

        let amountLabel = UILabel()
        amountLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let formatted = viewModel.formattedAmount(for: transaction)
        amountLabel.text = formatted.text
        amountLabel.textColor = formatted.color
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
