//
//  LogInVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 13/09/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class LogInVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var btnRememberMe: SSRememberMeButton!
    @IBOutlet weak var pswrdView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var eyeIcon: UIImageView!
    @IBOutlet weak var txtEmail: SSEmailTextField!
    @IBOutlet weak var txtPassword: SSPasswordTextField!
    
    var iconClick = true
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var rememberMeSelected = false

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
        txtEmail.text = self.getEmail()
        txtPassword.text = self.getPassword()
        btnRememberMe.isSelected = rememberMeSelected
        self.btnRememberMe.setImage(rememberMeSelected == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "uncheck"), for: .normal)
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtEmail.delegate = self
        txtPassword.delegate = self
      
        
    }
    open func signInApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.signIn, params: generatingParameters(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let loginResp = LoginSignUpData(dict:response as? [String : AnyHashable] ?? [:])
            let message = loginResp?.alertMessage ?? ""
            if let status = loginResp?.status  {
                if status == 200{
                    if self.rememberMeSelected == true{
                        storeCredential(email: self.txtEmail.text!, password: self.txtPassword.text!)
                    }else{
                        removeCredential()
                    }
                    setAppDefaults(loginResp?.access_token, key: "AuthToken")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier:"TabBarVC") as? TabBarVC
                    if let vc = vc {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    alert(AppAlertTitle.appName.rawValue, message: message, view: self)
                }
            }
            
        } failure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
    }
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["username"] = txtEmail.text  as AnyObject
        parameters["password"] = txtPassword.text  as AnyObject
        parameters["device_type"] = "2"  as AnyObject
        parameters["usertype"] = "2"  as AnyObject
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        parameters["device_token"] = deviceToken  as AnyObject
        print(parameters)
        return parameters
    }
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter email." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtEmail.text!, for: RegularExpressions.email) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid email address." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter password." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnForgot(_ sender: Any) {
        let controller = NavigationManager.shared.forgotPasswordVC
        push(controller: controller)
    }
   
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        validate() == false ? returnFunc() : signInApi()
    }
    
    @IBAction func btnRemeber(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.rememberMeSelected = sender.isSelected
        self.btnRememberMe.setImage(rememberMeSelected == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "uncheck"), for: .normal)
        if !rememberMeSelected{
            removeAppDefaults(key: "userEmail")
            removeAppDefaults(key: "userPassword")
        }
    }
    
    @IBAction func btnEye(_ sender: Any) {
        
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            eyeIcon.image = UIImage(named: SSImageName.iconEyeShow)
        } else {
            txtPassword.isSecureTextEntry = true
            eyeIcon.image = UIImage(named: SSImageName.iconEye)
        }
        iconClick = !iconClick
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtEmail:
            emailView.borderColor =  SSColor.appButton
        case txtPassword:
            pswrdView.borderColor =  SSColor.appButton
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtEmail:
            emailView.borderColor =  SSColor.appBlack
        case txtPassword:
            pswrdView.borderColor =  SSColor.appBlack
        default:break
        }
    }
    func getEmail() -> String
    {
        if let email =  UserDefaults.standard.value(forKey:"userEmail")
        {
            rememberMeSelected = true
            return email as! String
        }
        else
        {
            rememberMeSelected = false
            return ""
        }
    }
    
    func getPassword() -> String
    {
        if let password =  UserDefaults.standard.value(forKey:"userPassword")
        {
            rememberMeSelected = true
            return password as! String
        }
        else
        {
            rememberMeSelected = false
            return ""
            
        }
    }
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
