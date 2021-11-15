import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        present(TabBarViewController(nibName: "TabBarViewController", bundle: nil), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    } 
    
    @IBAction func OnClickSignIn(_ sender: Any) {
        let controler = SignInController(nibName: "SignInController", bundle: nil)
        navigationController?.pushViewController(controler, animated: true)
    }
    
    @IBAction func OnClickSignUp(_ sender: Any) {
        let controler = SignUpController(nibName: "SignUpController", bundle: nil)
        navigationController?.pushViewController(controler, animated: true)
    }
}

