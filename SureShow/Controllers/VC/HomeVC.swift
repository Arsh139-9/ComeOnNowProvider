//
//  HomeVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//

import UIKit
import Foundation
import Alamofire

class HomeVC : BaseVC, UITableViewDataSource, UITableViewDelegate, SegmentViewDelegate {
    
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var segment2: SegmentView!
    @IBOutlet weak var segment1: SegmentView!
    
    var section = ["",""]
    var date = "Feb 20 2021"
    var needToshowInfoView: Bool = false
    
    
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
        tblHome.delegate = self
        tblHome.dataSource = self
        
        segment1.btn.setTitle(LocalizableConstants.Controller.SureShow.confirmed.localized(), for: .normal)
        segment2.btn.setTitle(LocalizableConstants.Controller.SureShow.cancel.localized(), for: .normal)
        
        segment1.delegate = self
        segment2.delegate = self
    
        
        segment1.isSelected = true
        segment2.isSelected = !segment1.isSelected
        
        var identifier = String(describing: HomeConfirmedTVCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHome.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HomeCancelTVCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHome.register(nibCell, forCellReuseIdentifier: identifier)
        
        updateUI()
    }
    
    func updateUI() {
        
        tblHome.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment1.isSelected{
            return 5
        }else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segment1.isSelected {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeConfirmedTVCell.self)) as? HomeConfirmedTVCell {
                return cell
            }
        } else if segment2.isSelected {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCancelTVCell.self)) as? HomeCancelTVCell{
                return cell
            }
            
        } else {
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let view: ProfileViewForTitle = UIView.fromNib()
        view.titleLbl.text = "Feb 20 2021"
        view.layoutSubviews()
        return view.bounds.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view: ProfileViewForTitle = UIView.fromNib()
        view.titleLbl.text = date
        view.layoutSubviews()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segment1.isSelected == true{
            let controller = NavigationManager.shared.appointmentShowVC
            push(controller: controller)
            
        }else {
            let controller = NavigationManager.shared.appointmentDetailsVC
            push(controller: controller)
        }
    }
    
    //------------------------------------------------------
    
    //MARK: SegmentViewDelegate
    
    func segment(view: SegmentView, didChange flag: Bool) {
        
        tblHome.reloadData()
        self.needToshowInfoView = true
        
        if view == segment1 {
            
//            LoadingManager.shared.showLoading()
            segment2.isSelected = false
            
        } else if view == segment2 {
            
//            LoadingManager.shared.showLoading()
            segment1.isSelected = false
            
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tblHome.separatorStyle = .none
        tblHome.separatorColor = .clear
        
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
