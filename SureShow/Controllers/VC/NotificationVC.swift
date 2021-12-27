//
//  NotificationVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//


import UIKit
import KRPullLoader

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tblNotification: UITableView!
    var lastPageNo = 1
    var notificationListArr:[NotificationListData<AnyHashable>]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotification.dataSource = self
        tblNotification.delegate = self
        
        tblNotification.register(UINib(nibName: "NotificationsTVCell", bundle: nil), forCellReuseIdentifier: "NotificationsTVCell")
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        tblNotification.addPullLoadableView(loadMoreView, type: .loadMore)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastPageNo = 1
        getNotificationListApi()
        
    }
    func updateUI() {
        
        // Add the video preview layer to the view
        //        self.tabBarController?.tabBar.isHidden = false
        
        tblNotification.reloadData()
    }
    open func getNotificationListApi(){
        
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().getNotificationListApi(perPage:9, page: lastPageNo){ response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            
            let getNotificationDataResp  = GetNotificationListData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getNotificationDataResp?.message ?? ""
            if let status = getNotificationDataResp?.status{
                if status == 200{
                    self.lastPageNo = self.lastPageNo + 1
                    let notificationArr = getNotificationDataResp?.notificationListArray ?? []
                    
                    if notificationArr.count != 0{
                        DispatchQueue.main.async {
                            //                            self.noDataFoundView.isHidden = true
                        }
                        var notificationNUArray = [NotificationListData<AnyHashable>]()
                        
                        for i in 0..<notificationArr.count {
                            notificationNUArray.append(notificationArr[i])
                        }
                        notificationNUArray.sort {
                            $0.creation_date > $1.creation_date
                        }
                        let uniquePosts = notificationNUArray.unique{$0.id }
                        
                        self.notificationListArr = uniquePosts
                        
                        
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
}

extension NotificationVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVCell", for: indexPath) as! NotificationsTVCell
        cell.imgMain.sd_setImage(with: URL(string:notificationListArr?[indexPath.row].image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""), placeholderImage:UIImage(named:"placeholderProfileImg"))
        cell.lblName.text = notificationListArr?[indexPath.row].notify_title ?? ""
        
        cell.lblTime.text = notificationListArr?[indexPath.row].creation_date.components(separatedBy: .whitespaces).last == "" ? "11:30 AM":notificationListArr?[indexPath.row].creation_date.components(separatedBy: .whitespaces).last ?? ""
        cell.lblAppointment.text = notificationListArr?[indexPath.row].appoint_start_time ?? "" != "" && notificationListArr?[indexPath.row].appoint_end_time ?? "" != "" ? "\(returnFirstWordInString(string:notificationListArr?[indexPath.row].creation_date ?? "")), \(returnFirstWordInString(string:notificationListArr?[indexPath.row].appoint_start_time ?? ""))\(getAMPMFromTime(time: Int(notificationListArr?[indexPath.row].appoint_start_time ?? "") ?? 0)) to \(returnFirstWordInString(string:notificationListArr?[indexPath.row].appoint_end_time ?? ""))\(getAMPMFromTime(time:  Int(notificationListArr?[indexPath.row].appoint_end_time ?? "") ?? 0))" : "\(returnFirstWordInString(string:notificationListArr?[indexPath.row].creation_date ?? ""))"
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension NotificationVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    
                    self.getNotificationListApi()
                    
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
                self.getNotificationListApi()
                
            }
        }
    }
    
    
}



