//
//  UserListViewModel.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import Foundation
import Combine

enum SortType: String, CaseIterable {
    case ascending
    case descending
}

final class UserListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published var users: [UserViewData] = []
    @Published var isInitialLoading: Bool = false
    @Published var isError: Bool = false
    @Published var isLoadingNextPage: Bool = false
    
    @Published var sortType: SortType = .ascending {
        didSet {
            // Save to UserDefaults & sort
            UserDefaults.standard.set(sortType.rawValue, forKey: Self.sortKey)
            applySorting()
        }
    }
    
    // Core Data Service
    private let coreData = CoreDataService.shared
    
    // MARK: - Internal State
    private var rawUsers: [UserViewData] = []
    private var currentPage: Int = 1
    private var isLoading = false
    private var hasMore = true
    private var cancellables = Set<AnyCancellable>()
    private let apiService: GitHubAPIServiceProtocol
    
    // MARK: - Init
    init(apiService: GitHubAPIServiceProtocol = GitHubAPIService()) {
        self.apiService = apiService
        self.sortType = Self.loadSortType()
        setupBindings()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.resetAndSearch(query: text)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Sort Type Setter
    func setSortType(_ newType: SortType) {
        sortType = newType
    }
    
    // MARK: - Apply Sorting
    private func applySorting() {
        let sorted: [UserViewData]
        switch sortType {
        case .ascending:
            sorted = rawUsers.sorted { $0.username.lowercased() < $1.username.lowercased() }
        case .descending:
            sorted = rawUsers.sorted { $0.username.lowercased() > $1.username.lowercased() }
        }
        users = sorted
    }
    
    // MARK: - Search
    private func resetAndSearch(query: String) {
        currentPage = 1
        rawUsers = []
        users = []
        hasMore = true
        isError = false
        isInitialLoading = true
        searchFromAPI(query: query, page: currentPage)
    }
    
    private func searchFromAPI(query: String, page: Int) {
        guard !query.isEmpty, !isLoading, hasMore else {
            isInitialLoading = false
            return
        }

        isLoading = true
        if page > 1 {
            isLoadingNextPage = true
        }

        apiService.searchUsers(query: query, page: page)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                self.isLoading = false
                self.isLoadingNextPage = false
                self.isInitialLoading = false
                
                if case .failure = completion {
                    if self.currentPage == 1 {
                        self.isError = true
                    }
                }
            }, receiveValue: { [weak self] newUsers in
                guard let self = self else { return }

                let mapped = newUsers.map {
                    UserViewData(id: $0.id, username: $0.username, isFavorite: self.coreData.isUserFavorite(id: $0.id))
                }

                self.rawUsers.append(contentsOf: mapped)
                self.hasMore = !newUsers.isEmpty
                self.isError = false
                self.applySorting()
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Favorite Action
    func toggleFavorite(user: UserViewData) {
        if user.isFavorite {
            coreData.deleteFavoriteUser(id: user.id)
            updateFavoriteStatus(userId: user.id, isFavorite: false)
        } else {
            coreData.saveFavoriteUser(id: user.id, username: user.username)
            updateFavoriteStatus(userId: user.id, isFavorite: true)
        }
    }
    
    private func updateFavoriteStatus(userId: String, isFavorite: Bool) {
        if let index = rawUsers.firstIndex(where: { $0.id == userId }) {
            rawUsers[index].isFavorite = isFavorite
            applySorting()
        }
    }
    
    // MARK: - Infinite Scroll
    func loadNextPageIfNeeded(currentItem: UserViewData?) {
        guard let currentItem = currentItem else { return }
        guard !isLoading, hasMore else { return }

        let thresholdIndex = max(0, users.count - 5)
        if let currentIndex = users.firstIndex(where: { $0.id == currentItem.id }),
           currentIndex >= thresholdIndex {
            currentPage += 1
            searchFromAPI(query: searchText, page: currentPage)
        }
    }

    
    // MARK: - UserDefaults Helpers
    private static let sortKey = "sortTypeKey"
    
    private static func loadSortType() -> SortType {
        if let raw = UserDefaults.standard.string(forKey: sortKey),
           let type = SortType(rawValue: raw) {
            return type
        }
        return .ascending
    }
}
