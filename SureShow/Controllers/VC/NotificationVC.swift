//
//  NotificationVC.swift
//  SureShow
//
//  Created by Dharmani Apps on 15/09/21.
//


import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var tblNotification: UITableView!
    var NotificationArray = [NotificationData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNotification.dataSource = self
        tblNotification.delegate = self
        
        tblNotification.register(UINib(nibName: "NotificationsTVCell", bundle: nil), forCellReuseIdentifier: "NotificationsTVCell")
        self.NotificationArray.append(NotificationData(image: "uncle", details: "Grave Jodson accepted your appointment schedule on  Grave Jodson accepted your appointment schedule on", time : "11:35 AM", appointmentTime: "5-12-2021, 12:00 PM to 02:00 PM"))
        self.NotificationArray.append(NotificationData(image: "uncle", details: "Grave Jodson accepted your appointment schedule on", time : "11:35 AM", appointmentTime: "5-12-2021, 12:00 PM to 02:00 PM"))
        self.NotificationArray.append(NotificationData(image: "uncle", details: "Grave Jodson accepted your appointment schedule on", time : "11:35 AM", appointmentTime: "5-12-2021, 12:00 PM to 02:00 PM"))
    }
    
}

extension NotificationVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVCell", for: indexPath) as! NotificationsTVCell
        cell.imgMain.image = UIImage(named: NotificationArray[indexPath.row].image)
        cell.lblName.text = NotificationArray[indexPath.row].details
        cell.lblTime.text = NotificationArray[indexPath.row].time
        cell.lblAppointment.text = NotificationArray[indexPath.row].appointmentTime
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

struct NotificationData {
    var image : String
    var details : String
    var time : String
    var appointmentTime : String
    init(image : String, details : String , time : String, appointmentTime : String ) {
        self.image = image
        self.details = details
        self.time = time
        self.appointmentTime = appointmentTime
        
    }
}
