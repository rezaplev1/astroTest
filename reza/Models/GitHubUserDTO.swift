//
//  GitHubUserDTO.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import Foundation

struct GitHubUserResponse: Decodable {
    let totalCount: Int?
    let items: [GitHubUserDTO]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct GitHubUserDTO: Decodable {
    let id: Int?
    let login: String?
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
    }

    func toViewData() -> UserViewData? {
        guard let id = id, let login = login else { return nil }

        return UserViewData(
            id: String(id),
            username: login,
            isFavorite: false
        )
    }
}
