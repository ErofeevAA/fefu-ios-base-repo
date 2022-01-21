import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Профиль"
    }

    @IBAction func logoutAction(_ sender: Any) {
        print("call logout")
        
        let req = AuthRequests()
        
        req.logout() {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: "token")
                self.present(SignInController(nibName: "SignInController", bundle: nil), animated: true, completion: nil)
            }
        } errors: { error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                if(error.message == "Unauthenticated.") {
                    UserDefaults.standard.removeObject(forKey: "token")
                    self.present(SignInController(nibName: "SignInController", bundle: nil), animated: true, completion: nil)
                }
            }
        }
    }
}
