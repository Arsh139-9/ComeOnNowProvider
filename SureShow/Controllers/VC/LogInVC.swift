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
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        //        btnRememberMe.delegate = self
        if PreferenceManager.shared.rememberMeEmail.isEmpty == false {
            txtEmail.text = PreferenceManager.shared.rememberMeEmail
            btnRememberMe.isRemember = true
        } else {
            btnRememberMe.isRemember = false
        }
        
        if PreferenceManager.shared.rememberMePassword.isEmpty == false {
            txtPassword.text = PreferenceManager.shared.rememberMePassword
            btnRememberMe.isRemember = true
        } else {
            btnRememberMe.isRemember = false
        }
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter email address", okButton: "OK", controller: self ){
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtEmail.text!, for: RegularExpressions.email) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid email address", okButton: "OK", controller: self ){
                
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtPassword.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter password", okButton: "OK", controller: self ){
                
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
        
//        if validate() == false {
//            return
//        }
//
//        self.view.endEditing(true)
        
        let controller = NavigationManager.shared.tabBarVC
        push(controller: controller)
        
    }
    
    @IBAction func btnRemeber(_ sender: Any) {
        
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
