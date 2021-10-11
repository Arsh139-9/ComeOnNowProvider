//
//  AppointmentShowVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 16/09/21.
//

import UIKit
import Foundation

class AppointmentShowVC : BaseVC {
    
    @IBOutlet weak var lblDrName: SSMediumLabel!
    @IBOutlet weak var lblTime: SSMediumLabel!
    @IBOutlet weak var lblHospitalName: SSMediumLabel!
    @IBOutlet weak var lblDate: SSMediumLabel!
    @IBOutlet weak var lblParentName: SSMediumLabel!
    @IBOutlet weak var lblGender: SSMediumLabel!
    @IBOutlet weak var lblAge: SSMediumLabel!
    @IBOutlet weak var lblName: SSSemiboldLabel!
    @IBOutlet weak var imgMain: UIImageView!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
