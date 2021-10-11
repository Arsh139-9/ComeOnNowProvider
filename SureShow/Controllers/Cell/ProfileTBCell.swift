//
//  ProfileTBCell.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//

import UIKit

class ProfileTBCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: SSMediumLabel!
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup(image: String, name: String?) {
        
        imgIcon.image = UIImage(named: image)
        lblName.text = name
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
