//
//  HomeCancelTVCell.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//

import UIKit

class HomeCancelTVCell: UITableViewCell {

    @IBOutlet weak var lblTime: SSRegularLabel!
    @IBOutlet weak var lblDate: SSRegularLabel!
    @IBOutlet weak var lblGender: SSMediumLabel!
    @IBOutlet weak var lblAge: SSMediumLabel!
    @IBOutlet weak var lblName: SSSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
