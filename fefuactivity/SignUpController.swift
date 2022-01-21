//
//  SignUpController.swift
//  fefuactivity
//
//  Created by wsr1 on 16.10.2021.
//

import UIKit

class SignUpController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var repeatPasswordTextField: PasswordTextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    private let genderPickerView = UIPickerView()
    
    private let genders = ["Мужской", "Женский"]
    private var genderNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
                
        genderTextField.inputView = genderPickerView
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Регистрация"
        navigationItem.prompt = ""
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        genderNum = row
        return genders[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repeatPassword = repeatPasswordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let gender = 0

        if password != repeatPassword {
            presentAlert(title: "Ошибка", message: "Пароли не совпадают")
        }

        do {
            let registerParams = RegisterParams(login: login, password: password, name: name, gender: gender)
            let queue = DispatchQueue.global(qos: .utility)
            
            let encoder = JSONEncoder()
            let body = try encoder.encode(registerParams)
            
            let req = AuthRequests()

        req.auth(body: body, uri: "/register") { user in
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

                    self.presentAlert(title: "Проверьте поля", message: message)
                    
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
