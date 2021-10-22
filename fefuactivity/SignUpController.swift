//
//  SignUpController.swift
//  fefuactivity
//
//  Created by wsr1 on 16.10.2021.
//

import UIKit

class SignUpController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var iconTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    let genderPickerView = UIPickerView()
    
    let genders = ["", "Мужской", "Женский"]
    
    override func viewDidLoad() {
        iconTextField.rightViewMode = .unlessEditing
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
        return genders[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
}
