//
//  SignInController.swift
//  fefuactivity
//
//  Created by wsr1 on 21.10.2021.
//

import UIKit

class SignInController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Вход"
        navigationItem.prompt = ""
    }
}
