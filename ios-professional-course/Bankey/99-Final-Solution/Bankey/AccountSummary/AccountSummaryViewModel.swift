//
//  AccountSummaryViewModel.swift
//  Bankey
//

import UIKit

final class AccountSummaryViewModel {

    // MARK: - State (read-only externally)
    private(set) var profile: Profile?
    private(set) var accounts: [Account] = []
    private(set) var isLoaded = false

    // MARK: - Binding
    var onDataLoaded: (() -> Void)?

    // MARK: - Computed View Data

    var headerDataModel: AccountSummaryHeaderView.DataModel {
        AccountSummaryHeaderView.DataModel(
            welcomeMessage: "Good morning,",
            name: profile?.firstName ?? "",
            date: Date()
        )
    }

    // Returns 10 skeleton rows while loading, real rows once loaded.
    var accountCellDataModels: [AccountSummaryCell.DataModel] {
        if isLoaded {
            return accounts.map {
                AccountSummaryCell.DataModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
            }
        }
        let skeleton = Account.makeSkeleton()
        return Array(repeating: AccountSummaryCell.DataModel(
            accountType: skeleton.type,
            accountName: skeleton.name,
            balance: skeleton.amount
        ), count: 10)
    }

    // MARK: - Business Logic

    func fetchData() {
        guard let profileURL = Bundle.main.url(forResource: "profile", withExtension: "json"),
              let profileData = try? Data(contentsOf: profileURL) else { return }

        guard let accountsURL = Bundle.main.url(forResource: "accounts", withExtension: "json"),
              let accountsData = try? Data(contentsOf: accountsURL) else { return }

        profile = try? JSONDecoder().decode(Profile.self, from: profileData)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        accounts = (try? decoder.decode([Account].self, from: accountsData)) ?? []

        isLoaded = true
        onDataLoaded?()
    }

    func reset() {
        profile = nil
        accounts = []
        isLoaded = false
    }

    func titleAndMessage(for error: NetworkError) -> (String, String) {
        switch error {
        case .serverError:
            return ("Server Error", "We could not process your request. Please try again.")
        case .decodingError:
            return ("Network Error", "Ensure you are connected to the internet. Please try again.")
        }
    }
}
