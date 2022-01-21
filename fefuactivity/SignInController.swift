//
//  SignInController.swift
//  fefuactivity
//
//  Created by wsr1 on 21.10.2021.
//

import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    
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
    
    @IBAction func continueAction(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        do {
            let loginParams = LoginParams(login: login, password: password)
            let queue = DispatchQueue.global(qos: .utility)
            
            let encoder = JSONEncoder()
            let body = try encoder.encode(loginParams)
            
            let req = AuthRequests()

            req.auth(body: body, uri: "/login") { user in
                queue.async {
                    UserDefaults.standard.set(user.token, forKey: "token")
                }
                DispatchQueue.main.async {
                    self.present(TabBarViewController(nibName: "TabBarViewController", bundle: nil), animated: true, completion: nil)
                }
            } errors: { error in
                DispatchQueue.main.async {
                    var message = ""
                    for (_, item) in error.errors.reversed() {
                        message += item.joined(separator: "\n") + "\n"
                    }

                    let alert = UIAlertController(title: "Проверьте поля", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } catch {
            print(error)
        }
    }
}
