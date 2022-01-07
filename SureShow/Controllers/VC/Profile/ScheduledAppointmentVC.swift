//
//  ScheduledAppointmentVC.swift
//  SureShow
//
//  Created by apple on 08/12/21.
//

import UIKit

class ScheduledAppointmentVC:BaseVC,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tblScheduleAppointment: UITableView!
    @IBOutlet weak var scheduleAppointmentNotFoundPopUpView: UIView!
    
    var lastPageNo:Int?
    var appointmentScheduleListArr:[ScheduledAppointmentListData<AnyHashable>]?
    var getAppointmentTypeListArray:[AppointmentTypeListData<AnyHashable>]?

    
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        tblScheduleAppointment.delegate = self
        tblScheduleAppointment.dataSource = self
        let identifier = String(describing: ScheduledAppointmentTBCell.self)
        let nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblScheduleAppointment.register(nibCell, forCellReuseIdentifier: identifier)
    }
    open func getScheduledAppointmentListsApi(){
        
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().getScheduledAppointmentListApi(perPage:5000, page: lastPageNo ?? 0){ response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let getAppointmentDataResp  = GetScheduledAppointmentData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getAppointmentDataResp?.message ?? ""
            if let status = getAppointmentDataResp?.status{
                if status == 200{
                    self.lastPageNo = self.lastPageNo ?? 0 + 1
                    let getAppointmentListArr = getAppointmentDataResp?.addAppointmentListArray ?? []
                    
                    if getAppointmentListArr.count != 0{
                        DispatchQueue.main.async {
                            //                            self.noDataFoundView.isHidden = true
                        }
                        var addAppointmentListNUArr = [ScheduledAppointmentListData<AnyHashable>]()
                        
                        for i in 0..<getAppointmentListArr.count {
                            addAppointmentListNUArr.append(getAppointmentListArr[i])
                        }
                        addAppointmentListNUArr.sort {
                            $0.id > $1.id
                        }
                        let uniquePosts = addAppointmentListNUArr.unique{$0.id }
                        
                        self.appointmentScheduleListArr = uniquePosts
                        
                    }else{
                        DispatchQueue.main.async {
                            //                            self.noDataFoundView.isHidden = false
                        }
                    }
                    self.updateUI()
                }
                else if status == 401{
                    removeAppDefaults(key:"AuthToken")
                    appDel.logOut()
                }else{
                    self.scheduleAppointmentNotFoundPopUpView.isHidden = false

                }
                
            }
            
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    func updateUI() {
        tblScheduleAppointment.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentScheduleListArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ScheduledAppointmentTBCell.self)) as? ScheduledAppointmentTBCell {
            cell.lblDate.text = appointmentScheduleListArr?[indexPath.row].appoint_date
            cell.lblTime.text =  appointmentScheduleListArr?[indexPath.row].appoint_start_time ?? "" != "" && appointmentScheduleListArr?[indexPath.row].appoint_end_time ?? "" != "" ? "\(appointmentScheduleListArr?[indexPath.row].appoint_start_time ?? "") - \(appointmentScheduleListArr?[indexPath.row].appoint_end_time ?? "")" : ""
            cell.btnType.setTitle(appointmentScheduleListArr?[indexPath.row].patient_type == 1 ? "Adult" : "Child", for: .normal)
//            appointmentScheduleListArr?[indexPath.row].appointment_type == getAppointmentTypeListArray?[indexPath.row].id ? self.getAppointmentTypeListArray?[indexPath.row].name ?? "" : ""
            cell.lblAppointmentType.text = appointmentScheduleListArr?[indexPath.row].appointment_type ?? ""
            cell.lblDisease.text = appointmentScheduleListArr?[indexPath.row].disease
            cell.lblTitle.text = appointmentScheduleListArr?[indexPath.row].appointment_title
            cell.lblDescription.text = appointmentScheduleListArr?[indexPath.row].description
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    //MARK: GET APPOINTMENT TYPE
    @objc func getAppointmentTypes(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let appointmentTypeArr = userInfo["appointmentTypes"] as? [AppointmentTypeListData<AnyHashable>] {
                getAppointmentTypeListArray = appointmentTypeArr
            }
        }
    }
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getAppointmentTypes(notification:)), name:NSNotification.Name(rawValue: "SendAppointmentType"), object: nil)


        setup()
        tblScheduleAppointment.separatorStyle = .none
        tblScheduleAppointment.separatorColor = .clear
    }
   
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleAppointmentNotFoundPopUpView.isHidden = true
        lastPageNo = 1
        getScheduledAppointmentListsApi()
    }
    
    //------------------------------------------------------
}
