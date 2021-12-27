//
//  AppointmentVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 16/09/21.
//
import UIKit
import Foundation
import KRPullLoader
class AppointmentVC : BaseVC,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblAppointment: UITableView!
    
    
    var lastPageNo:Int?
    var addAppointmentListArr:[AddAppointmentListData<AnyHashable>]?
    var diseaseListArr:[DiseaseListData<AnyHashable>]?
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
        tblAppointment.delegate = self
        tblAppointment.dataSource = self
        
        var identifier = String(describing: HomeConfirmedTVCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAppointment.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HomeCancelTVCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAppointment.register(nibCell, forCellReuseIdentifier: identifier)
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblAppointment.addPullLoadableView(loadMoreView, type: .loadMore)
        
    }
    
    func updateUI() {
        
        tblAppointment.reloadData()
    }
    open func getDiseaseListApi(){
        ModalResponse().getDiseaseListApi(){ response in
            print(response)
            let getDiseaseDataResp  = GetDiseaseData(dict:response as? [String : AnyHashable] ?? [:])
            AFWrapperClass.svprogressHudDismiss(view: self)

            let message = getDiseaseDataResp?.message ?? ""
            if let status = getDiseaseDataResp?.status{
                if status == 200{
                    self.diseaseListArr = getDiseaseDataResp?.diseaseListArray ?? []
                }
                else if status == 401{
                    removeAppDefaults(key:"AuthToken")
                    appDel.logOut()
                }
                else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    open func getAppointmentTypeListApi(){
        ModalResponse().getAppointmentTypeApi(){ response in
            print(response)
            let getDiseaseDataResp  = GetAppointmentTypeData(dict:response as? [String : AnyHashable] ?? [:])
            AFWrapperClass.svprogressHudDismiss(view: self)

            let message = getDiseaseDataResp?.message ?? ""
            if let status = getDiseaseDataResp?.status{
                if status == 200{
                    self.getAppointmentTypeListArray = getDiseaseDataResp?.getAppointmentTypeListArray ?? []
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendAppointmentType"), object: nil, userInfo: ["appointmentTypes":self.getAppointmentTypeListArray ?? []])

                    
                }
                else if status == 401{
                    removeAppDefaults(key:"AuthToken")
                    appDel.logOut()
                }
                else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    open func getAppointmentListsApi(){
        
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().getAppointmentListApi(perPage:9, page: lastPageNo ?? 0, status: 2){ response in
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
                        
                        self.addAppointmentListArr = uniquePosts
                        
                        
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
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                    
                }
                
            }
            
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addAppointmentListArr?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeConfirmedTVCell.self)) as? HomeConfirmedTVCell {
            let birthday = getDateFormatter().date(from: addAppointmentListArr?[indexPath.row].dob ?? "")
            let age =  birthday != nil ? returnAge(birthday:birthday) : 0
            cell.lblAge.text = "\(age) years old"
            cell.lblName.text = "\(addAppointmentListArr?[indexPath.row].last_name ?? "") \(addAppointmentListArr?[indexPath.row].first_name ?? "")"
            cell.lblGender.text =  addAppointmentListArr?[indexPath.row].gender  == 1 ? "Male" : addAppointmentListArr?[indexPath.row].gender  == 2 ? "Female" : "Others"
            cell.lblDate.text = addAppointmentListArr?[indexPath.row].appoint_date
            
            cell.lblTime.text =  addAppointmentListArr?[indexPath.row].appoint_start_time ?? "" != "" && addAppointmentListArr?[indexPath.row].appoint_end_time ?? "" != "" ? "\(addAppointmentListArr?[indexPath.row].appoint_start_time ?? "") - \(addAppointmentListArr?[indexPath.row].appoint_end_time ?? "")" : ""
            
            cell.imgMain.sd_setImage(with: URL(string:                 addAppointmentListArr?[indexPath.row].image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                                              ), placeholderImage:UIImage(named:"place"))
            return cell
        }
        
        
        //            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCancelTVCell.self)) as? HomeCancelTVCell{
        //                return cell
        //            }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
            let controller = NavigationManager.shared.appointmentDetailsVC
            controller.addAppointmentListDict = addAppointmentListArr?[indexPath.row]
            push(controller: controller)
        
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnAdd(_ sender: Any) {
        let controller = NavigationManager.shared.addAppointmentVC
        controller.getAppointmentTypeListArray = getAppointmentTypeListArray
        controller.diseaseListArr = diseaseListArr
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tblAppointment.separatorStyle = .none
        tblAppointment.separatorColor = .clear
        getDiseaseListApi()
        getAppointmentTypeListApi()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastPageNo = 1
        getAppointmentListsApi()
        
    }
    
    //------------------------------------------------------
}
extension AppointmentVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    self.getAppointmentListsApi()
                    
                }
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                self.getAppointmentListsApi()

                
            }
        }
    }
    
    
}

