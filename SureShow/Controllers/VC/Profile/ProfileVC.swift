//
//  ProfileVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//

import UIKit
import Foundation
import Alamofire

class ProfileVC : BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var userNameLbl: SSMediumLabel!
    
    @IBOutlet weak var emailLbl: SSRegularLabel!
    
    var getProfileResp: GetUserProfileData<Any>?

    struct ProfileItems {
        
        static let changePassword = LocalizableConstants.Controller.Profile.changePassword
        static let changePasswordIcon = SSImageName.iconChangePassword
        static let about = LocalizableConstants.Controller.Profile.about
        static let aboutIcon = SSImageName.iconAbout
        static let history = LocalizableConstants.Controller.Profile.history
        static let HistoryIcon = SSImageName.iconHistory
        static let scheduledAppointment = LocalizableConstants.Controller.Profile.scheduleAppointment
        static let scheduledAppointmentIcon = SSImageName.iconHistory
        static let privacyPolicy = LocalizableConstants.Controller.Profile.privacy
        static let privacyPolicyIcon = SSImageName.iconPrivacy
        static let termsOfServices = LocalizableConstants.Controller.Profile.termsOfService
        static let termsOfServicesIcon = SSImageName.iconTerm
        static let logout = LocalizableConstants.Controller.Profile.logout
        static let logoutIcon = SSImageName.iconLogout
        
    }
    
    var itemNormal: [ [String:String] ] {
        return [
            
            ["name": ProfileItems.changePassword, "image": ProfileItems.changePasswordIcon],
            ["name": ProfileItems.about, "image": ProfileItems.aboutIcon],
            ["name": ProfileItems.history, "image": ProfileItems.HistoryIcon],
            ["name": ProfileItems.scheduledAppointment, "image": ProfileItems.scheduledAppointmentIcon],
            ["name": ProfileItems.privacyPolicy, "image": ProfileItems.privacyPolicyIcon],
            ["name": ProfileItems.termsOfServices, "image": ProfileItems.termsOfServicesIcon],
            ["name": ProfileItems.logout, "image": ProfileItems.logoutIcon]
        ]
    }
    
    var items: [ [String: String] ] {
        
        return itemNormal
    }
    
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
        tblProfile.delegate = self
        tblProfile.dataSource = self
        let identifier = String(describing: ProfileTBCell.self)
        let nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblProfile.register(nibProfileCell, forCellReuseIdentifier: identifier)        
    }
    
    func updateUI() {
        
        tblProfile.reloadData()
    }
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        
        parameters["type"] = "2"  as AnyObject
        
        //        parameters["device_type"] = "1"  as AnyObject
        //        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        //        if deviceToken == ""{
        //            deviceToken = "123"
        //        }
        //        parameters["device_token"] = deviceToken  as AnyObject
        print(parameters)
        return parameters
    }
    open func getProfileApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getUserDetail, params:nil, headers: headers) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            self.getProfileResp  = GetUserProfileData(dict:response as? [String : AnyHashable] ?? [:])
            let message = self.getProfileResp?.message ?? ""
            
            if let status = self.getProfileResp?.status{
                if status == 200{
                    DispatchQueue.main.async {
                        self.userNameLbl.text = "\(self.getProfileResp?.first_name ?? "") \(self.getProfileResp?.last_name ?? "")"
                        self.emailLbl.text = self.getProfileResp?.email ?? ""
                        var sPhotoStr = self.getProfileResp?.image ?? ""
                        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
                        self.imgProfile.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"place"))
                    }
                 
                }
                else if status == 401{
                    removeAppDefaults(key:"AuthToken")
                    appDel.logOut()
                    
                }
                else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    open func logOutApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.logOut, params:nil, headers: headers) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int {
                if status == 200{
                    removeAppDefaults(key:"AuthToken")
                    appDel.logOut()
                }
                else if status == 401{
                    removeAppDefaults(key:"AuthToken")
                    appDel.logOut()
                    
                }
                else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnEdit(_ sender: Any) {
        let controller = NavigationManager.shared.editProfileVC
        controller.getProfileResp = getProfileResp
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let name = item["name"]
        let image = item["image"]!
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTBCell.self)) as? ProfileTBCell {
            cell.setup(image: image, name: name?.localized())
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let name = item["name"]
        name == ProfileItems.changePassword ? navPToChangePassword(name: name) : name == ProfileItems.history ? navPToHistory() : name == ProfileItems.scheduledAppointment ? navPToScheduleAppointment() : name == ProfileItems.about ? navPToAbout() : name == ProfileItems.privacyPolicy ? navPToPrivacyPolicy() : name == ProfileItems.termsOfServices ? navPToTermOfServices() : logOutFromApp()
 

    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        tblProfile.separatorStyle = .none
        imgProfile.circle()
        getProfileApi()

    }
    
    //------------------------------------------------------
}
extension ProfileVC{
    func navPToChangePassword(name:String?){
        let controller = NavigationManager.shared.changePasswordVC
        controller.textTitle = name?.localized()
        push(controller: controller)
    }
    func navPToHistory(){
        let controller = NavigationManager.shared.historyVC
        push(controller: controller)
    }
    func navPToScheduleAppointment(){
        let controller = NavigationManager.shared.scheduledAppointmentVC
        push(controller: controller)
    }
    func navPToAbout(){
        let controller = NavigationManager.shared.aboutVC
        push(controller: controller)
    }
    func navPToPrivacyPolicy(){
        let controller = NavigationManager.shared.privacyVC
        push(controller: controller)
    }
    func navPToTermOfServices(){
        let controller = NavigationManager.shared.serviceVC
        push(controller: controller)
    }
    func logOutFromApp(){
        DisplayAlertManager.shared.displayAlertWithNoYes(target: self, animated: true, message: LocalizableConstants.ValidationMessage.confirmLogout.localized()) {
            //Nothing to handle
            
        } handlerYes: {
            self.logOutApi()
            
        }
    }
}
