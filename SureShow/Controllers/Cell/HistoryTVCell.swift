//
//  HistoryTVCell.swift
//  SureShow
//
//  Created by Dharmani Apps on 14/09/21.
//

import UIKit

class HistoryTVCell: UITableViewCell {

    @IBOutlet weak var lblTime: SSMediumLabel!
    @IBOutlet weak var lblDate: SSMediumLabel!
    @IBOutlet weak var lblGender: SSMediumLabel!
    @IBOutlet weak var lblAge: SSMediumLabel!
    @IBOutlet weak var lblName: SSSemiboldLabel!
    @IBOutlet weak var imgmain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
