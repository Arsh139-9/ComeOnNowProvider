//
//  ChangePasswordVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 14/09/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class ChangePasswordVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var confirmPswrdView: UIView!
    @IBOutlet weak var newPswrdView: UIView!
    @IBOutlet weak var chngPswrdView: UIView!
    @IBOutlet weak var txtOldPassword: SSPasswordTextField!
    @IBOutlet weak var txtNewPassword: SSPasswordTextField!
    @IBOutlet weak var txtConfirmPassword: SSPasswordTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var textTitle: String?
    
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
        
        title = textTitle
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtOldPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtOldPassword.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter password" , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtNewPassword.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter new password" , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtNewPassword.text!, for: RegularExpressions.password8AS) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid new password. Password should contain at least 8 characters, with at least 1 letter and 1 special character." , okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtConfirmPassword.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter confirm password." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isValid(text: txtConfirmPassword.text!, for: RegularExpressions.password8AS) == false {
            showAlertMessage(title: kAppName.localized(), message: "Please enter valid confirm password. Password should contain at least 8 characters, with at least 1 letter and 1 special character." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if (txtOldPassword.text == txtNewPassword.text) {
            showAlertMessage(title: kAppName.localized(), message: "The old and new password must not be the same." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if (txtNewPassword.text != txtConfirmPassword.text) {
            showAlertMessage(title: kAppName.localized(), message: "New passwords and confirm password not match.", okButton: "Ok", controller: self) {
            }
            
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validate() == false {
            return
        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case txtOldPassword:
            chngPswrdView.borderColor =  SSColor.appButton
        case txtNewPassword :
            newPswrdView.borderColor = SSColor.appButton
        case txtConfirmPassword :
            confirmPswrdView.borderColor = SSColor.appButton
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtOldPassword:
            chngPswrdView.borderColor =  SSColor.appBlack
        case txtNewPassword :
            newPswrdView.borderColor = SSColor.appBlack
        case txtConfirmPassword :
            confirmPswrdView.borderColor = SSColor.appBlack
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


