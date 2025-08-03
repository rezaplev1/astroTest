//
//  UserListViewController.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import UIKit
import SwiftUI

final class UserListViewController: BaseViewController {
    private let viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        embed(UserListView(viewModel: viewModel), in: view, topPadding: 0)
        bindViewModel()
    }
    
    func bindViewModel() {

    }
}
