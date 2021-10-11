//
//  EditProfileVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 14/09/21.
//


import UIKit
import Toucan
import SDWebImage
import Foundation
import Alamofire
import IQKeyboardManagerSwift
import SKCountryPicker


class EditProfileVC : BaseVC, UITextViewDelegate, UITextFieldDelegate, ImagePickerDelegate {
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtLastName: SSUsernameTextField!
    @IBOutlet weak var txtFirstName: SSUsernameTextField!
    
    @IBOutlet weak var txtMobileNumber: SSMobileNumberTextField!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var countryCodeLbl: SSSemiboldLabel!
    @IBOutlet weak var txtEmail: SSEmailTextField!
    
    var returnKeyHandler: IQKeyboardReturnKeyHandler?
    var imagePickerVC: ImagePicker?
    var selectedImage: UIImage? {
        didSet {
            if selectedImage != nil {
                imgProfile.image = selectedImage
            }
        }
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
        //        imgProfile.image = getPlaceholderImage()
        imagePickerVC = ImagePicker(presentationController: self, delegate: self)
        
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnKeyHandler?.delegate = self
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtMobileNumber.delegate = self
        
    }
    
    func validate() -> Bool {
        
        if ValidationManager.shared.isEmpty(text: txtFirstName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter first name", okButton: "OK", controller: self ){
                
            }
            return false
        }
        if ValidationManager.shared.isEmpty(text: txtLastName.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter last name", okButton: "OK", controller: self ){
                
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtEmail.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter email address", okButton: "OK", controller: self ){
                
            }
            return false
        }
        
        if ValidationManager.shared.isEmpty(text: txtMobileNumber.text) == true {
            showAlertMessage(title: kAppName.localized(), message: "Please enter mobile number.", okButton: "OK", controller: self ){
                
            }
            return false
        }
        
        return true
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func countryCodePickerBtnAction(_ sender: Any) {
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            let selectedCountryCode = country.dialingCode
            //            let selectedCountryName = self.flag(country:country.countryCode)
            let selectedCountryVal = "\(selectedCountryCode ?? "")"
            self.countryCodeLbl.text = selectedCountryVal
            //            self.countryCodeBtn.setTitle(selectedCountryVal, for: .normal)
            
            setAppDefaults(country.dialingCode, key: "countryName")
            
            
        }
        
        countryController.detailColor = UIColor.red
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    @IBAction func btnProfileImg(_ sender: Any) {
        self.imagePickerVC?.present(from: (sender as? UIView)!)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if validate() == false {
            return
        }
        LoadingManager.shared.showLoading()
        
    }
    
    //------------------------------------------------------
    
    //MARK: SSImagePickerDelegate
    
    func didSelect(image: UIImage?) {
        if let imageData = image?.jpegData(compressionQuality: 0), let compressImage = UIImage(data: imageData) {
            self.selectedImage = Toucan.init(image: compressImage).resizeByCropping(SSSettings.profileImageSize).maskWithRoundedRect(cornerRadius: SSSettings.profileImageSize.width/2, borderWidth: SSSettings.profileBorderWidth, borderColor: UIColor.white).image
            imgProfile.image = selectedImage
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
        case txtEmail:
            emailView.borderColor =  SSColor.appButton
        case txtFirstName:
            firstNameView.borderColor =  SSColor.appButton
        case txtLastName:
            lastNameView.borderColor =  SSColor.appButton
        case txtMobileNumber:
            phoneView.borderColor =  SSColor.appButton
        default:break
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case txtEmail:
            emailView.borderColor = SSColor.appBlack
        case txtFirstName:
            firstNameView.borderColor = SSColor.appBlack
        case txtLastName:
            lastNameView.borderColor = SSColor.appBlack
        case txtMobileNumber:
            phoneView.borderColor = SSColor.appBlack
            
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
        self.countryCodeBtn.contentHorizontalAlignment = .center
        self.countryCodeBtn.clipsToBounds = true
        
        
//        if getProfileResp?.cellno != ""{
//            let arr = getProfileResp?.cellno.components(separatedBy:"-")
//
//            txtMobileNumber.text = arr?.count ?? 0 > 1 ? arr?[1] : arr?[0]
//            for obj in CountryManager.shared.countries{
//                if obj.dialingCode == arr?[0]{
//                    let selectedCountryCode = obj.dialingCode
//                    countryCodeLbl.text = selectedCountryCode
//
//                    //                    self.countryCodeBtn.setTitle(selectedCountryCode, for: .normal)
//                    setAppDefaults(obj.dialingCode, key: "countryName")
//
//                    break
//                }
//
//            }
//        }else{
            guard let country = CountryManager.shared.currentCountry else {
                return
            }
            countryCodeLbl.text = country.dialingCode
            setAppDefaults("+1", key: "countryName")
            
            //            setAppDefaults(country.countryName, key: "countryName")
        //}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgProfile.circle()
    }
    
    //------------------------------------------------------
}
