//
//  UserViewData.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import Foundation

struct UserViewData: Identifiable {
    let id: String
    let username: String
    var isFavorite: Bool = false
}
