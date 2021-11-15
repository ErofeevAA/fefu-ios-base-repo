import UIKit

class ActivityDetailsViewController: UIViewController {
    
    var params: ParamsTableCell!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startEndLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    // timeAgoLabel мало не бывает
    @IBOutlet weak var secondTimeAgoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = params.type
        
        distanceLabel.text = params.distance
        durationLabel.text = params.duration
        
        timeAgoLabel.text = params.timeAgo
        secondTimeAgoLabel.text = params.timeAgo
        
        startEndLabel.text =  "Старт: \(params.startTime) • Финиш: \(params.endTime)"
        typeLabel.text = params.type
        iconView.image = params.icon
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let rightBar = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightBar
    }

}
