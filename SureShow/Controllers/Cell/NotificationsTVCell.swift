//
//  NotificationsTVCell.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//

import UIKit
import SDWebImage
import Toucan

class NotificationsTVCell: UITableViewCell {

    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblName: SSMediumLabel!
    @IBOutlet weak var lblAppointment: SSRegularLabel!
    @IBOutlet weak var lblTime: SSMediumLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
