//
//  AppointmentDetailsVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 16/09/21.
//

import UIKit
import Foundation

class AppointmentDetailsVC : BaseVC {
    
    @IBOutlet weak var lblTime: SSMediumLabel!
    @IBOutlet weak var lblDate: SSMediumLabel!
    @IBOutlet weak var lblGuardian: SSMediumLabel!
    @IBOutlet weak var lblGender: SSMediumLabel!
    @IBOutlet weak var lblAge: SSMediumLabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblName: SSSemiboldLabel!
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnAppointment(_ sender: Any) {
        let controller = NavigationManager.shared.addAppointmentVC
        push(controller: controller)
        
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
