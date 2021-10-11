//
//  AddQueueVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 04/10/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class AddQueueVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var txtName: SSUserNameDropDownTextField!
    @IBOutlet weak var txtBirthDate: SSBirthDateTextField!
    @IBOutlet weak var txtGender: SSGenderTextField!
    @IBOutlet weak var txtHospitalName: SSHospitalTextField!
    @IBOutlet weak var txtProvider: SSProviderTextField!
    @IBOutlet weak var txtDisease: SSDiseaseTextField!
    @IBOutlet weak var birthView: UIView!
    @IBOutlet weak var diseaseView: UIView!
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
        
        txtName.delegate = self
        txtBirthDate.delegate = self
        txtGender.delegate = self
        txtDisease.delegate = self
        txtHospitalName.delegate = self
        txtProvider.delegate = self
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter name." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtBirthDate.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select date of birth." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtGender.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select gender." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtHospitalName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select hospital name" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtProvider.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select provider" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtDisease.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select disease name." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
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
        case txtName:
            nameView.borderColor =  SSColor.appButton
        case txtBirthDate :
            txtBirthDate.borderColor = SSColor.appButton
        case txtGender :
            txtGender.borderColor = SSColor.appButton
        case txtHospitalName :
            txtHospitalName.borderColor = SSColor.appButton
        case txtProvider :
            txtProvider.borderColor = SSColor.appButton
        case txtDisease:
            diseaseView.borderColor =  SSColor.appButton
            
            
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtName:
            nameView.borderColor =  SSColor.appBlack
        case txtBirthDate :
            birthView.borderColor = SSColor.appBlack
        case txtGender :
            txtGender.borderColor = SSColor.appBlack
        case txtHospitalName :
            txtHospitalName.borderColor = SSColor.appBlack
        case txtProvider :
            txtProvider.borderColor = SSColor.appBlack
        case txtDisease:
            diseaseView.borderColor =  SSColor.appBlack
            
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
