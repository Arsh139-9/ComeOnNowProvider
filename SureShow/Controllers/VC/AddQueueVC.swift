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
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtBirthDate: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtHospitalName: UITextField!
    @IBOutlet weak var txtProvider: UITextField!
    @IBOutlet weak var txtDisease: UITextField!
    @IBOutlet weak var txtBranch: UITextField!
    @IBOutlet weak var birthView: UIView!
    @IBOutlet weak var diseaseView: UIView!
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    
    var patientListArr = [PatientListData<AnyHashable>]()
    var hospitalListArr = [HospitalListData<AnyHashable>]()
    var branchListArr = [BranchListData<AnyHashable>]()
    var providerListArr = [ProviderListData<AnyHashable>]()
    var diseaseListArr = [DiseaseListData<AnyHashable>]()
    
    var pvOptionArr = [String]()
    var hospitalId:Int?
    var branchId:Int?
    var hospitalSId:Int?
    var branchSId:Int?
    var patientSId:Int?
    var providerSId:Int?
    var diseaseSId:Int?
    var globalPickerView:UIPickerView?
    
    
    
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
        getPatientListApi()
        getDiseaseListApi()
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtName.delegate = self
        txtName.tintColor = .clear
        txtHospitalName.tintColor = .clear

        txtBirthDate.delegate = self
        txtGender.delegate = self
        txtDisease.delegate = self
        txtHospitalName.delegate = self
        txtBranch.delegate  = self
        txtProvider.delegate = self
        globalPickerView?.delegate = self
        globalPickerView?.dataSource = self
        
        let label = UILabel(frame: CGRect(x:0, y:0, width:300, height:19))
        label.center = CGPoint(x: view.frame.midX, y: view.frame.height)
        label.textAlignment = NSTextAlignment.center
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        let toolbarTitle = UIBarButtonItem(customView: label)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closePicker))
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.setItems([cancelButton, toolbarTitle, doneButton], animated: false)
        
     
        txtName.inputView = globalPickerView
        txtName.inputAccessoryView = toolBar
        
        txtHospitalName.inputView = globalPickerView
        txtHospitalName.inputAccessoryView = toolBar
        
        txtBranch.inputAccessoryView = toolBar
        txtProvider.inputAccessoryView = toolBar
        
        txtDisease.inputView = globalPickerView
        txtDisease.inputAccessoryView = toolBar
        
        
        txtBranch.setupRightImage(imageName:SSImageName.iconDropDown)
        txtHospitalName.setupRightImage(imageName:SSImageName.iconDropDown)
        txtProvider.setupRightImage(imageName:SSImageName.iconDropDown)
        
        
        
        
    }
    @objc func closePicker() {
        txtName.resignFirstResponder()
        txtHospitalName.resignFirstResponder()
        txtProvider.resignFirstResponder()
        txtBranch.resignFirstResponder()
        txtDisease.resignFirstResponder()
    }
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter name." , okButton: "Ok", controller: self) {
            }
            return false
        }
        
//        if ValidationManager.shared.isEmpty(text: txtBirthDate.text) == true {
//            showAlertMessage(title: kAppName.localized(), message: "Please select date of birth." , okButton: "Ok", controller: self) {
//
//            }
//            return false
//        }
//        if ValidationManager.shared.isEmpty(text: txtGender.text) == true {
//            showAlertMessage(title: kAppName.localized(), message: "Please select gender." , okButton: "Ok", controller: self) {
//                
//            }
//            return false
//        }
        if ValidationManager.shared.isEmpty(text: txtHospitalName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select hospital name" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtBranch.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select branch" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtProvider.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select provider" , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtDisease.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please select disease." , okButton: "Ok", controller: self) {
                
            }
            return false
        }
        return true
    }
    
    open func getPatientListApi(){
        ModalResponse().getPatientListApi(){ response in
            print(response)
            let getPatientDataResp  = GetPatientData(dict:response as? [String : AnyHashable] ?? [:])
            let message = getPatientDataResp?.message ?? ""
            if let status = getPatientDataResp?.status{
                if status == 200{
                    self.patientListArr = getPatientDataResp?.patientListArray ?? []
//                    self.pvOptionArr.removeAll()
//                    for obj in self.patientListArr {
//                        self.pvOptionArr.append("\(obj.last_name) \(obj.first_name)")
//                    }
//                    self.txtName.pvOptions = self.pvOptionArr
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
    open func getDiseaseListApi(){
        ModalResponse().getDiseaseListApi(){ response in
            print(response)
            let getDiseaseDataResp  = GetDiseaseData(dict:response as? [String : AnyHashable] ?? [:])
            AFWrapperClass.svprogressHudDismiss(view: self)
            
            let message = getDiseaseDataResp?.message ?? ""
            if let status = getDiseaseDataResp?.status{
                if status == 200{
                    self.diseaseListArr = getDiseaseDataResp?.diseaseListArray ?? []

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
    
    open func getBranchListApi(){
        for obj in hospitalListArr {
            if obj.clinic_name == txtHospitalName.text{
                hospitalId = obj.clinic_id
                break
            }
        }
        
        ModalResponse().getBranchListApi(clinicId:hospitalId ?? 0){ response in
            print(response)
            let getBranchDataResp  = GetBranchData(dict:response as? [String : AnyHashable] ?? [:])
            AFWrapperClass.svprogressHudDismiss(view: self)
            let message = getBranchDataResp?.message ?? ""
            if let status = getBranchDataResp?.status{
                if status == 200{
                    self.branchListArr = getBranchDataResp?.branchListArray ?? []
                  
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
    open func getProviderListApi(){
        for obj in branchListArr {
            if obj.branch_name == txtBranch.text{
                branchId = obj.id
                break
            }
        }
        ModalResponse().getProviderListApi(clinicId:hospitalId ?? 0, branchId: branchId ?? 0){ response in
            print(response)
            let getProviderDataResp  = GetProviderData(dict:response as? [String : AnyHashable] ?? [:])
            AFWrapperClass.svprogressHudDismiss(view: self)
            let message = getProviderDataResp?.message ?? ""
            if let status = getProviderDataResp?.status{
                if status == 200{
                    self.providerListArr = getProviderDataResp?.providerListArray ?? []
                    
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
 
    
    open func addQueueApi(){
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        ModalResponse().addQueueListApi(params:generatingParameters()) { response in
            AFWrapperClass.svprogressHudDismiss(view: self)
            print(response)
            let message = response["message"] as? String ?? ""
            if let status = response["status"] as? Int {
                if status == 200{
                    showAlertMessage(title: kAppName.localized(), message: message , okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
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
        } onFailure: { error in
            AFWrapperClass.svprogressHudDismiss(view: self)
            alert(AppAlertTitle.appName.rawValue, message: error.localizedDescription, view: self)
        }
        
        
    }
    func generatingParameters() -> [String:AnyObject] {
        var parameters:[String:AnyObject] = [:]
        parameters["clinic_id"] =  hospitalSId as AnyObject
        parameters["branch_id"] = branchSId  as AnyObject
        parameters["add_user_id"] = patientSId  as AnyObject
        parameters["disease_id"] = diseaseSId  as AnyObject
        
        print(parameters)
        return parameters
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        validate() == false ? returnFunc() : addQueueApi()
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
     func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
      }
      
       func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
      }
      
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
      }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .clear
        
        globalPickerView?.reloadAllComponents()
        switch textField {
        case txtName:
            nameView.borderColor =  SSColor.appButton
        case txtBirthDate :
            txtBirthDate.borderColor = SSColor.appButton
        case txtGender :
            txtGender.borderColor = SSColor.appButton
        case txtHospitalName :
            txtHospitalName.borderColor = SSColor.appButton
        case txtBranch :
            if txtHospitalName.text != ""{
                txtBranch.inputView = globalPickerView
            }
          
            txtBranch.borderColor = SSColor.appButton
        case txtProvider :
            if txtBranch.text != ""{
                txtProvider.inputView = globalPickerView
            }
            txtProvider.borderColor = SSColor.appButton
        case txtDisease:
            diseaseView.borderColor =  SSColor.appButton
            
            
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.tintColor = .clear

        switch textField {
        case txtName:
            nameView.borderColor =  SSColor.appBlack
        case txtBirthDate :
            birthView.borderColor = SSColor.appBlack
        case txtGender :
            txtGender.borderColor = SSColor.appBlack
        case txtHospitalName :
            txtHospitalName.borderColor = SSColor.appBlack
        case txtBranch :
            txtBranch.borderColor = SSColor.appBlack
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
// MARK: UIPickerView DataSource
extension AddQueueVC:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if txtName.isFirstResponder == true{
            return patientListArr.count
        }
        else if txtHospitalName.isFirstResponder == true{
            return hospitalListArr.count
        }else if txtBranch.isFirstResponder == true{
            return branchListArr.count
        }else if txtProvider.isFirstResponder == true{
            return providerListArr.count
        }
        else if txtDisease.isFirstResponder{
            return diseaseListArr.count
        }
        else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtName.isFirstResponder == true{
            return "\(patientListArr[row].last_name) \(patientListArr[row].first_name)"
        }
        else if txtHospitalName.isFirstResponder {
            return hospitalListArr[row].clinic_name
        } else if txtBranch.isFirstResponder {
            return branchListArr[row].branch_name
        } else if txtProvider.isFirstResponder {
            return providerListArr[row].name
        }  else if txtDisease.isFirstResponder{
            return diseaseListArr[row].disease_name
        }
        else{
            return "0"
        }
    }
}
// MARK: UIPickerView Delegates
extension AddQueueVC:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if txtName.isFirstResponder == true{
            txtName.text = "\(patientListArr[row].last_name) \(patientListArr[row].first_name)"
            patientSId = patientListArr[row].id
        }
        else if txtHospitalName.isFirstResponder {
            txtHospitalName.text = hospitalListArr[row].clinic_name
            hospitalSId = hospitalListArr[row].clinic_id
            
            getBranchListApi()
        } else if txtBranch.isFirstResponder {
            txtBranch.text = branchListArr[row].branch_name
            branchSId = branchListArr[row].id
            
            getProviderListApi()
        } else if txtProvider.isFirstResponder {
            txtProvider.text = providerListArr[row].name
            providerSId = providerListArr[row].id
            
        }
        else if txtDisease.isFirstResponder {
            txtDisease.text = diseaseListArr[row].disease_name
            diseaseSId = diseaseListArr[row].id
            
        }
    }
}
