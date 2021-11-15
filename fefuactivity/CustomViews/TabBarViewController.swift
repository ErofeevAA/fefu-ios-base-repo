import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let activityController = UINavigationController(rootViewController: ActivitiesViewController())
        let profileController = UINavigationController(rootViewController: ProfileViewController())
        activityController.tabBarItem.title = "Активности"
        profileController.tabBarItem.title = "Профиль"
        activityController.tabBarItem.image = UIImage(systemName: "circle")
        profileController.tabBarItem.image = UIImage(systemName: "circle")
        self.setViewControllers([activityController, profileController], animated: true)
        modalPresentationStyle = .overFullScreen
    }

}
