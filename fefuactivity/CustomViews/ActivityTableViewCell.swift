
import UIKit

struct ParamsTableCell {
    let distance: Double
    let duration: Double
    let date: Date
    let icon: UIImage?
    let type: String
    let startTime: String
    let endTime: String
}

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ params: ParamsTableCell) {
        distanceLabel.text = String(format: "%.2f км", params.distance / 1000)
        
        let duration = DateComponentsFormatter()
        duration.allowedUnits = [.hour, .minute, .second]
        duration.zeroFormattingBehavior = .pad
        
        durationLabel.text = duration.string(from: params.duration)
        iconView.image = params.icon
        typeLabel.text = params.type
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        timeAgoLabel.text = df.string(from: params.date)
    }
    
}
