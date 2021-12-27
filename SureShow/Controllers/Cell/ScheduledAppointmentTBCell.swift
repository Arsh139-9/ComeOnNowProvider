//
//  ScheduledAppointmentTBCell.swift
//  SureShow
//
//  Created by apple on 09/12/21.
//

import UIKit

class ScheduledAppointmentTBCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAppointmentType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDisease: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnType: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
