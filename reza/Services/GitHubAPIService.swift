//
//  GitHubAPIService.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import Foundation
import Combine

protocol GitHubAPIServiceProtocol {
    func searchUsers(query: String, page: Int) -> AnyPublisher<[UserViewData], Error>
}

final class GitHubAPIService: GitHubAPIServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient(baseURL: URL(string: "https://api.github.com")!)) {
        self.apiClient = apiClient
    }

    func searchUsers(query: String, page: Int) -> AnyPublisher<[UserViewData], Error> {
        let request = APIRequest(
            path: "search/users",
            method: .get,
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "30")
            ],
            headers: ["Accept": "application/vnd.github.v3+json"],
            body: nil
        )

        return apiClient.request(request, responseType: GitHubUserResponse.self)
            .map {
                $0.items.compactMap { $0.toViewData() }
            }
            .eraseToAnyPublisher()
    }
}
