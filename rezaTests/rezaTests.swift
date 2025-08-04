//
//  rezaTests.swift
//  rezaTests
//
//  Created by reza pahlevi on 03/08/25.
//

import XCTest
@testable import reza

class UserListViewModelTests: XCTestCase {
    var viewModel: UserListViewModel!
    var mockAPI: MockGitHubAPIService!

    override func setUp() {
        super.setUp()
        mockAPI = MockGitHubAPIService()
        viewModel = UserListViewModel(apiService: mockAPI)
    }

    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }

    func testInitialUsersEmpty() {
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testSearchAppendsUsers() {
        mockAPI.mockUsers = [
            UserViewData(id: "1", username: "reza", isFavorite: false),
            UserViewData(id: "2", username: "john", isFavorite: true)
        ]

        let expectation = self.expectation(description: "Search completes")
        viewModel.searchText = "re"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.users.count, 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }

}

