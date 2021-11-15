
import UIKit

struct ParamsTableCell {
    let distance: String
    let duration: String
    let timeAgo: String
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
        distanceLabel.text = params.distance
        durationLabel.text = params.duration
        iconView.image = params.icon
        typeLabel.text = params.type
        timeAgoLabel.text = params.timeAgo
    }
    
}
