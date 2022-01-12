//
//  ActivityTypeViewCell.swift
//  fefuactivity
//
//  Created by wsr1 on 23.12.2021.
//

import UIKit

struct ActivityTypeCellParams {
    let type: String
    let title: String
}

class ActivityTypeViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var type: String?
    var title: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        cellView.layer.cornerRadius = 14
        cellView.layer.borderColor = UIColor.gray.cgColor
        cellView.layer.borderWidth = 1
    }
    
    func setFields(cell: ActivityTypeCellParams) {
        type = cell.type
        title = cell.title
        typeLabel.text = type
    }

}
