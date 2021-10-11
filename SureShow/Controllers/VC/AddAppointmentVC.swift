//
//  AddAppointmentVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 14/09/21.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class AddAppointmentVC : BaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var txtAppointmentType: SSAppointmentTypeTextField!
    @IBOutlet weak var txtAppntEnd: SSSelectDateTextFieldForEndTime!
    @IBOutlet weak var txtAppntStart: SSSelectDateTextFieldForStartTime!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var diseaseView: UIView!
    @IBOutlet weak var appointView: UIView!
    @IBOutlet weak var birthView: UIView!
    @IBOutlet weak var txtViewDescription: SSMediumWithoutBorderTextView!
    @IBOutlet weak var txtTitle: SSTitleTextField!
    @IBOutlet weak var txtDisease: SSDDiseaseTextField!
    @IBOutlet weak var txtAppointment: SSAppointmentTextField!
    @IBOutlet weak var unchKRBtn: UIButton!
    
    @IBOutlet weak var cHKRBtn: UIButton!
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
        
        txtAppointment.delegate = self
        txtDisease.delegate = self
        txtTitle.delegate = self
        txtViewDescription.delegate = self
        
    }
    
    func validate() -> Bool {
        
     
        
       
        if ValidationManager.shared.isEmpty(text: txtAppointment.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select appointment date" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtAppntStart.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select appointment start time." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtAppntEnd.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select appointment end time." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtAppointmentType.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select appointment type" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtDisease.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter disease name." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtTitle.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter title." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtViewDescription.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter description." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    @IBAction func unchekRadioBtnAction(_ sender: UIButton) {
        //        inventoryCount = "2"
        unchKRBtn.setImage(UIImage(named: "sel"), for:UIControl.State.normal)
        cHKRBtn.setImage(UIImage(named: "un"), for:UIControl.State.normal)
    }
    
    @IBAction func chckRadioBtnAction(_ sender: UIButton) {
        //        inventoryCount = "1"
        unchKRBtn.setImage(UIImage(named: "un"), for:UIControl.State.normal)
        cHKRBtn.setImage(UIImage(named: "sel"), for:UIControl.State.normal)
        
    }
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
       
        
        case txtAppntStart :
            txtAppntStart.borderColor = SSColor.appButton
        case txtAppntEnd :
            txtAppntEnd.borderColor = SSColor.appButton
        case txtAppointment :
            txtAppointment.borderColor = SSColor.appButton
        case txtDisease:
            diseaseView.borderColor =  SSColor.appButton
        case txtTitle :
            titleView.borderColor = SSColor.appButton
            
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
       
        case txtAppntStart :
            txtAppntStart.borderColor = SSColor.appBlack
        case txtAppntEnd :
            txtAppntEnd.borderColor = SSColor.appBlack
        case txtAppointment :
            txtAppointment.borderColor = SSColor.appBlack
        case txtDisease:
            diseaseView.borderColor =  SSColor.appBlack
        case txtTitle :
            titleView.borderColor = SSColor.appBlack
        default:break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtViewDescription.tintColor = SSColor.appButton
        descriptionView.borderColor = SSColor.appButton
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        descriptionView.borderColor = SSColor.appBlack
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
