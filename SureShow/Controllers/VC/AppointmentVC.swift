//
//  AppointmentVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 16/09/21.
//
import UIKit
import Foundation
import Alamofire

class AppointmentVC : BaseVC,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblAppointment: UITableView!
    
    var section = ["",""]
    var date = "Feb 20 2021"
    
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
        tblAppointment.delegate = self
        tblAppointment.dataSource = self
        
        
        var identifier = String(describing: HomeConfirmedTVCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAppointment.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HomeCancelTVCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblAppointment.register(nibCell, forCellReuseIdentifier: identifier)
        
        
        updateUI()
        
    }
    
    func updateUI() {
        
        tblAppointment.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else {
            return 3
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeConfirmedTVCell.self)) as? HomeConfirmedTVCell {
                return cell
            }
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCancelTVCell.self)) as? HomeCancelTVCell{
                return cell
            }
        }
        
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let view: ProfileViewForTitle = UIView.fromNib()
//        view.titleLbl.text = "Feb 20 2021"
//        view.layoutSubviews()
//        return view.bounds.height
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let view: ProfileViewForTitle = UIView.fromNib()
//        view.titleLbl.text = date
//        view.layoutSubviews()
//        return view
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let controller = NavigationManager.shared.appointmentShowVC
            push(controller: controller)
        }else {
            let controller = NavigationManager.shared.appointmentDetailsVC
            push(controller: controller)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnAdd(_ sender: Any) {
        let controller = NavigationManager.shared.addAppointmentVC
        push(controller: controller)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tblAppointment.separatorStyle = .none
        tblAppointment.separatorColor = .clear
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
