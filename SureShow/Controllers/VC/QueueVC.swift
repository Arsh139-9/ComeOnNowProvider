//
//  QueueVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//


import UIKit
import KRPullLoader

class QueueVC: UIViewController {
    
    @IBOutlet weak var tblQueue: UITableView!
    @IBOutlet weak var queueNotFoundPopUpView: UIView!
    
    
    var addQueueListArr:[AddAppointmentListData<AnyHashable>]?
    var lastPageNo = 0
    var hospitalListArr = [HospitalListData<AnyHashable>]()
    var addQueueListNUArr = [AddAppointmentListData<AnyHashable>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getHospitalListApi()
        tblQueue.dataSource = self
        tblQueue.delegate = self
        tblQueue.register(UINib(nibName: "QueueTVCell", bundle: nil), forCellReuseIdentifier: "QueueTVCell")
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblQueue.addPullLoadableView(loadMoreView, type: .loadMore)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queueNotFoundPopUpView.isHidden = true
        lastPageNo = 1
        getQueueListsApi()
    }
    
    func updateUI() {
        
        tblQueue.reloadData()
    }
    open func getQueueListsApi(){
        
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().getAppointmentListApi(perPage:5000, page: lastPageNo , status: 1){ response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            
            let getQueueDataResp  = GetAddAppointmentData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getQueueDataResp?.message ?? ""
            if let status = getQueueDataResp?.status{
                if status == 200{
                    self.lastPageNo = self.lastPageNo + 1
                    let getQueueListArr = getQueueDataResp?.addAppointmentListArray ?? []
                    
                    if getQueueListArr.count != 0{
                        DispatchQueue.main.async {
                            //                            self.noDataFoundView.isHidden = true
                        }
                        
                        for i in 0..<getQueueListArr.count {
                            self.addQueueListNUArr.append(getQueueListArr[i])
                        }
                        self.addQueueListNUArr.sort {
                            $0.id > $1.id
                        }
                        let uniquePosts = self.addQueueListNUArr.unique{$0.id}
                        self.addQueueListArr = uniquePosts
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
                    self.queueNotFoundPopUpView.isHidden = self.addQueueListArr?.count ?? 0 == 0 ? false : true
                    
                }
                
            }
            
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    open func getHospitalListApi(){
        ModalResponse().getHospitalListApi(){ response in
            print(response)
            let getHospitalDataResp  = GetHospitalData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getHospitalDataResp?.message ?? ""
            if let status = getHospitalDataResp?.status{
                if status == 200{
                    self.hospitalListArr = getHospitalDataResp?.hospitalListArray ?? []
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
    
    @IBAction func btnAdd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddQueueVC") as! AddQueueVC
        vc.globalPickerView = UIPickerView()
        vc.hospitalListArr = hospitalListArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension QueueVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addQueueListArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueueTVCell", for: indexPath) as! QueueTVCell
        let birthday = getDateFormatter().date(from: addQueueListArr?[indexPath.row].dob ?? "")
        let timeInterval = birthday?.timeIntervalSinceNow
        let age = abs(Int(timeInterval! / 31556926.0))
        cell.lblAge.text = "\(age) years old"
        cell.lblGender.text =  addQueueListArr?[indexPath.row].gender  == 1 ? "Male" : addQueueListArr?[indexPath.row].gender  == 2 ? "Female" : "Others"
        cell.lblName.text = "\(addQueueListArr?[indexPath.row].last_name ?? "") \(addQueueListArr?[indexPath.row].first_name ?? "")"
        cell.lblAppointment.text = addQueueListArr?[indexPath.row].appoint_start_time ?? "" != "" && addQueueListArr?[indexPath.row].appoint_end_time ?? "" != "" ? "\(addQueueListArr?[indexPath.row].appoint_date ?? ""), \(returnFirstWordInString(string:addQueueListArr?[indexPath.row].appoint_start_time ?? ""))\(getAMPMFromTime(time: Int(addQueueListArr?[indexPath.row].appoint_start_time ?? "") ?? 0)) - \(returnFirstWordInString(string:addQueueListArr?[indexPath.row].appoint_end_time ?? ""))\(getAMPMFromTime(time:  Int(addQueueListArr?[indexPath.row].appoint_end_time ?? "") ?? 0))" : "\(addQueueListArr?[indexPath.row].appoint_date ?? "")"
        cell.imgProfile.sd_setImage(with: URL(string:                 addQueueListArr?[indexPath.row].image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                                             ), placeholderImage:UIImage(named:"placeholderProfileImg"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
}

extension QueueVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    self.getQueueListsApi()
                    
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
                self.getQueueListsApi()

                
            }
        }
    }
    
    
}

