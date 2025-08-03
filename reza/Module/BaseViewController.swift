//
//  BaseViewController.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import UIKit
import SwiftUI

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: false)
     }
    
    func embed<Content: View>(_ swiftUIView: Content, in container: UIView,
                              topPadding: CGFloat = 0) {
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        container.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: container.topAnchor, constant: topPadding),
            hostingController.view.topAnchor.constraint(equalTo: container.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

}
