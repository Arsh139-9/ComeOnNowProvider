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
    var diseaseListArr:[DiseaseListData<AnyHashable>]?
    var getAppointmentTypeListArray:[AppointmentTypeListData<AnyHashable>]?
    var globalPickerView = UIPickerView()
    var patientType:Int?
    var diseaseId:Int?
    var appointmentTypeId:Int?
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
        patientType = 1

        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtAppointment.delegate = self
        txtDisease.delegate = self
        txtTitle.delegate = self
        txtViewDescription.delegate = self
        globalPickerView.delegate = self
        globalPickerView.dataSource = self
        let label = UILabel(frame: CGRect(x:0, y:0, width:300, height:19))
        label.text = kAppName
        label.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        label.textAlignment = NSTextAlignment.center
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        let toolbarTitle = UIBarButtonItem(customView: label)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closePicker))
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.setItems([cancelButton, toolbarTitle, doneButton], animated: false)
        
        //        let buttons = [barButtonItem1, barButtonItem,barButtonItem2]
        //        toolBar.setItems(buttons, animated: false)
        txtDisease.inputView = globalPickerView
        txtDisease.inputAccessoryView = toolBar
        txtAppointmentType.inputView = globalPickerView
        txtAppointmentType.inputAccessoryView = toolBar
    }
    @objc func closePicker() {
        txtDisease.resignFirstResponder()
        txtAppointmentType.resignFirstResponder()
        
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
        patientType = 2
        unchKRBtn.setImage(UIImage(named: "sel"), for:UIControl.State.normal)
        cHKRBtn.setImage(UIImage(named: "un"), for:UIControl.State.normal)
    }
    
    @IBAction func chckRadioBtnAction(_ sender: UIButton) {
        patientType = 1
        unchKRBtn.setImage(UIImage(named: "un"), for:UIControl.State.normal)
        cHKRBtn.setImage(UIImage(named: "sel"), for:UIControl.State.normal)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        validate() == false ? returnFunc() : addScheduleAppointmentApi()
    }
    
    //MARK: Add Schedule Appointment Api
    open func addScheduleAppointmentApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().addScheduledAppointmentListApi(params:generatingParameters()) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let getAppointmentDataResp  = GetScheduledAppointmentData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getAppointmentDataResp?.message ?? ""
            if let status = getAppointmentDataResp?.status{
                if status == 200{
                    showAlertMessage(title: kAppName.localized(), message: message , okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
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
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["appointment_title"] =  txtTitle.text as AnyObject
        parameters["patient_type"] = patientType as AnyObject
        parameters["disease"] = diseaseId  as AnyObject
        parameters["appoint_date"] = txtAppointment.text  as AnyObject
        parameters["appoint_start_time"] = txtAppntStart.text as AnyObject
        parameters["appoint_end_time"] = txtAppntEnd.text as AnyObject
        parameters["appointment_type"] = appointmentTypeId as AnyObject
        parameters["description"] = txtViewDescription.text as AnyObject
        
        print(parameters)
        return parameters
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
// MARK: UIPickerView DataSource
extension AddAppointmentVC:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return txtDisease.isFirstResponder == true ? self.diseaseListArr?.count ?? 0 : txtAppointmentType.isFirstResponder == true ? self.getAppointmentTypeListArray?.count ?? 0 : 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return txtDisease.isFirstResponder  ? self.diseaseListArr?[row].disease_name ?? "" : txtAppointmentType.isFirstResponder  ? self.getAppointmentTypeListArray?[row].name ?? "" : "0"
    }
}
// MARK: UIPickerView Delegates
extension AddAppointmentVC:UIPickerViewDelegate{
    func setDiseaseDataSelectFromPicker(diseaseId:Int,diseaseName:String){
        txtDisease.text = diseaseName
        self.diseaseId = diseaseId
    }
    func setAppointmentDataSelectFromPicker(appointmentTypeId:Int,appointmentTypeName:String){
        txtAppointmentType.text = appointmentTypeName
        self.appointmentTypeId = appointmentTypeId
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtDisease.isFirstResponder ? setDiseaseDataSelectFromPicker(diseaseId: self.diseaseListArr?[row].id ?? 0, diseaseName: self.diseaseListArr?[row].disease_name ?? "") : txtAppointmentType.isFirstResponder  ?  setAppointmentDataSelectFromPicker(appointmentTypeId: self.getAppointmentTypeListArray?[row].id ?? 0, appointmentTypeName: self.getAppointmentTypeListArray?[row].name ?? "") : nil
    }
}
