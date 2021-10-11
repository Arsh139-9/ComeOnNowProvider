//
//  QueueVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//


import UIKit

class QueueVC: UIViewController {
    
    @IBOutlet weak var tblQueue: UITableView!
    var QueueArray = [QueueData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblQueue.dataSource = self
        tblQueue.delegate = self
        
        tblQueue.register(UINib(nibName: "QueueTVCell", bundle: nil), forCellReuseIdentifier: "QueueTVCell")
        self.QueueArray.append(QueueData(image: "uncle", details: "Grave accepted your appointment schedule on", gender: "Male" ,  age: "75 years old", appointmentTime: "5-12-2021, 12:00 PM to 02:00 PM"))
        self.QueueArray.append(QueueData(image: "uncle", details: "Grave accepted your appointment schedule on", gender: "Male" , age: "75 years old", appointmentTime: "5-12-2021, 12:00 PM to 02:00 PM"))
        self.QueueArray.append(QueueData(image: "uncle", details: "Grave accepted your appointment schedule on", gender: "Male" , age: "75 years old", appointmentTime: "5-12-2021, 12:00 PM to 02:00 PM"))
    }
    
    
    @IBAction func btnAdd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddQueueVC") as! AddQueueVC
               self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension QueueVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QueueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueueTVCell", for: indexPath) as! QueueTVCell
        cell.imgProfile.image = UIImage(named: QueueArray[indexPath.row].image)
        cell.lblAge.text = QueueArray[indexPath.row].age
        cell.lblAppointment.text = QueueArray[indexPath.row].appointmentTime
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
}

struct QueueData {
    var image : String
    var details : String
    var gender : String
    var age : String
    var appointmentTime : String
    init(image : String, details : String , gender : String, age : String, appointmentTime : String ) {
        self.image = image
        self.details = details
        self.gender = gender
        self.age = age
        self.appointmentTime = appointmentTime
        
    }
}
