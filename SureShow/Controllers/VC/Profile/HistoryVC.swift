//
//  HistoryVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 14/09/21.
//

import UIKit
import Foundation

class HistoryVC : BaseVC, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var noHistoryFoundPopUpView: UIView!
    
    
    var lastPageNo:Int?
    var appointmentHistoryListArr:[AddAppointmentListData<AnyHashable>]?
    
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
        tblHistory.delegate = self
        tblHistory.dataSource = self
        
        
        var identifier = String(describing: HistoryTVCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHistory.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HomeCancelTVCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHistory.register(nibCell, forCellReuseIdentifier: identifier)

        
        
    }
    open func getAppointmentHistoryListsApi(){
        
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().getAppointmentHistoryListApi(perPage:5000, page: lastPageNo ?? 0){ response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let getAppointmentDataResp  = GetAddAppointmentData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getAppointmentDataResp?.message ?? ""
            if let status = getAppointmentDataResp?.status{
                if status == 200{
                    self.lastPageNo = self.lastPageNo ?? 0 + 1
                    let getAppointmentListArr = getAppointmentDataResp?.addAppointmentListArray ?? []
                    
                    if getAppointmentListArr.count != 0{
                        DispatchQueue.main.async {
                            //                            self.noDataFoundView.isHidden = true
                        }
                        var addAppointmentListNUArr = [AddAppointmentListData<AnyHashable>]()
                        
                        for i in 0..<getAppointmentListArr.count {
                            addAppointmentListNUArr.append(getAppointmentListArr[i])
                        }
                        addAppointmentListNUArr.sort {
                            $0.id > $1.id
                        }
                        let uniquePosts = addAppointmentListNUArr.unique{$0.id }
                        
                        self.appointmentHistoryListArr = uniquePosts
                        
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
                    self.noHistoryFoundPopUpView.isHidden = false

                    
                }
                
            }
            
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    func updateUI() {
        
        tblHistory.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appointmentHistoryListArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell =  (indexPath.section == 0 ? tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryTVCell.self)) as? HistoryTVCell :
//                        tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCancelTVCell.self)) as? HomeCancelTVCell) ?? UITableViewCell()
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryTVCell.self)) as? HistoryTVCell {
                let birthday = getDateFormatter().date(from: appointmentHistoryListArr?[indexPath.row].dob ?? "")
                let timeInterval = birthday?.timeIntervalSinceNow
                let age = abs(Int(timeInterval! / 31556926.0))
                cell.lblAge.text = "\(age) years old"
                cell.lblName.text = "\(appointmentHistoryListArr?[indexPath.row].last_name ?? "") \(appointmentHistoryListArr?[indexPath.row].first_name ?? "")"
                cell.lblGender.text =  appointmentHistoryListArr?[indexPath.row].gender  == 1 ? "Male" : appointmentHistoryListArr?[indexPath.row].gender  == 2 ? "Female" : "Others"
                cell.lblDate.text = appointmentHistoryListArr?[indexPath.row].appoint_date
                
                cell.lblTime.text =  appointmentHistoryListArr?[indexPath.row].appoint_start_time ?? "" != "" && appointmentHistoryListArr?[indexPath.row].appoint_end_time ?? "" != "" ? "\(appointmentHistoryListArr?[indexPath.row].appoint_start_time ?? "") - \(appointmentHistoryListArr?[indexPath.row].appoint_end_time ?? "")" : ""
                
                cell.imgmain.sd_setImage(with: URL(string:                 appointmentHistoryListArr?[indexPath.row].image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                                                  ), placeholderImage:UIImage(named:"placeholderProfileImg"))
                return cell
            }
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tblHistory.separatorStyle = .none
        tblHistory.separatorColor = .clear
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noHistoryFoundPopUpView.isHidden = true
        lastPageNo = 1
        getAppointmentHistoryListsApi()
    }
    
    //------------------------------------------------------
}
