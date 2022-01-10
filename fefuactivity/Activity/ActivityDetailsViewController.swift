import UIKit

class ActivityDetailsViewController: UIViewController {
    
    var params: ParamsTableCell!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startEndLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var secondTimeAgoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = params.type
        
        distanceLabel.text = String(format: "%.2f км", params.distance / 1000)
        
        let duration = DateComponentsFormatter()
        duration.allowedUnits = [.hour, .minute, .second]
        duration.zeroFormattingBehavior = .pad
        durationLabel.text = duration.string(from: params.duration)
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        timeAgoLabel.text = dateFormater.string(from: params.date)
        secondTimeAgoLabel.text = dateFormater.string(from: params.date)
        
        startEndLabel.text =  "Старт: \(params.startTime) • Финиш: \(params.endTime)"
        typeLabel.text = params.type
        iconView.image = params.icon
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let rightBar = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = rightBar
    }

}
