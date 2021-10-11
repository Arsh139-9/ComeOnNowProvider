//
//  HistoryVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 14/09/21.
//

import UIKit
import Foundation

class HistoryVC : BaseVC, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tblHistory: UITableView!
    
    var section = ["",""]
    
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
        tblHistory.delegate = self
        tblHistory.dataSource = self
        
        
        var identifier = String(describing: HistoryTVCell.self)
        var nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHistory.register(nibCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HomeCancelTVCell.self)
        nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHistory.register(nibCell, forCellReuseIdentifier: identifier)
        
        
        updateUI()
        
    }
    
    func updateUI() {
        
        tblHistory.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else {
            return 3
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryTVCell.self)) as? HistoryTVCell {
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
//        view.titleLbl.text = "Feb 20 2021"
//        view.layoutSubviews()
//        return view
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.pop()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tblHistory.separatorStyle = .none
        tblHistory.separatorColor = .clear
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
