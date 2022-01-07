//
//  ForgotPasswordVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 13/09/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class ForgotPasswordVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtEmail: SSMediumTextField!
    
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
        return true
    }
    open func forgotPasswordApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.forgotPassword, params: generatingParameters(), headers: nil) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title: kAppName.localized(), message: message , okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
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
        parameters["usertype"] = "2"  as AnyObject
        
        print(parameters)
        return parameters
    }
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnSubmit(_ sender: Any) {
        validate() == false ? returnFunc() : forgotPasswordApi()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.borderColor =  SSColor.appButton
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.borderColor =  SSColor.appBlack
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
