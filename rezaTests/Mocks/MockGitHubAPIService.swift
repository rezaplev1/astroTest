//
//  MockGitHubAPIService.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import Combine
@testable import reza

class MockGitHubAPIService: GitHubAPIServiceProtocol {
    var mockUsers: [UserViewData] = []

    func searchUsers(query: String, page: Int) -> AnyPublisher<[UserViewData], Error> {
        return Just(mockUsers)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
