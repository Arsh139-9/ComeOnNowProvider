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
    
    var addAppointmentListDict:AddAppointmentListData<AnyHashable>?
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    func appointmentDetailSetUp(){
        let birthday = getDateFormatter().date(from: addAppointmentListDict?.dob ?? "")
        let timeInterval = birthday?.timeIntervalSinceNow
        let age = abs(Int(timeInterval! / 31556926.0))
        lblAge.text = "\(age) years old"
        lblName.text = "\(addAppointmentListDict?.last_name ?? "") \(addAppointmentListDict?.first_name ?? "")"
        lblGender.text =  addAppointmentListDict?.gender  == 1 ? "Male" : addAppointmentListDict?.gender  == 2 ? "Female" : "Others"
        lblDate.text = addAppointmentListDict?.appoint_date
        
        
        //addAppointmentListDict?.appoint_start_time ?? "" != "" && addAppointmentListDict?.appoint_end_time ?? "" != "" ? "\(returnFirstWordInString(string:addAppointmentListDict?.appoint_start_time ?? ""))\(getAMPMFromTime(time: Int(addAppointmentListDict?.appoint_start_time ?? "") ?? 0)) - \(returnFirstWordInString(string:addAppointmentListDict?.appoint_end_time ?? ""))\(getAMPMFromTime(time:  Int(addAppointmentListDict?.appoint_end_time ?? "") ?? 0))" : ""
        lblTime.text =  addAppointmentListDict?.appoint_start_time ?? "" != "" && addAppointmentListDict?.appoint_end_time ?? "" != "" ? "\(addAppointmentListDict?.appoint_start_time ?? "") - \(addAppointmentListDict?.appoint_end_time ?? "")" : ""
        
        imgMain.sd_setImage(with: URL(string:addAppointmentListDict?.image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""), placeholderImage:UIImage(named:"place"))
        lblGuardian.text = addAppointmentListDict?.loginuser_name ?? ""
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
        appointmentDetailSetUp()
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
