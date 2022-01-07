//
//  GetAppointmentDataEntity.swift
//  SureShow
//
//  Created by apple on 07/12/21.
//

import Foundation

struct GetAddAppointmentData<T>{
 
    var status: Int
    var message: String
    var addAppointmentListArray:[AddAppointmentListData<T>]
    
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataArr = dict["data"] as? [[String:T]] ?? [[:]]
        
        self.status = status
        self.message = alertMessage
        var hArray = [AddAppointmentListData<T>]()
        for obj in dataArr{
            let childListObj = AddAppointmentListData(dataDict:obj)!
            hArray.append(childListObj)
        }
        self.addAppointmentListArray = hArray
    }
}


struct AddAppointmentListData<T>{
    var id:Int
    var user_id:String
    var name:String
    var first_name:String
    var last_name:String
    var status:Int
    var image:String
    var type:String
    var dob:String
    var gender:Int
    var loginuser_name:String
    var relationship:String
    var age:Int
    var appoint_date:String
    var appoint_start_time:String
    var appoint_end_time:String
    var appointment_type:String
    var description:String

    
    init?(dataDict:[String:T]) {
        
        let id = dataDict["id"] as? Int ?? 0
        let user_id = dataDict["user_id"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let first_name = dataDict["first_name"] as? String ?? ""
        let last_name = dataDict["last_name"] as? String ?? ""

        let image = dataDict["image"] as? String ?? ""
        let type = dataDict["type"] as? String ?? ""
        let dob = dataDict["dob"] as? String ?? ""
        let gender = dataDict["gender"] as? Int ?? 0
        let status = dataDict["status"] as? Int ?? 0

        let loginuser_name = dataDict["loginuser_name"] as? String ?? ""
        let relationship = dataDict["relationship"] as? String ?? ""
        let age = dataDict["age"] as? Int ?? 0
        let appoint_date = dataDict["appoint_date"] as? String ?? ""
        let appoint_start_time = dataDict["appoint_start_time"] as? String ?? ""
        let appoint_end_time = dataDict["appoint_end_time"] as? String ?? ""
        let appointment_type = dataDict["appointment_type"] as? String ?? ""
        let description = dataDict["description"] as? String ?? ""

        
        
        self.id = id
        self.user_id = user_id
        self.name = name
        self.first_name = first_name
        self.last_name = last_name

        self.image = image
        self.type = type
        self.dob = dob
        self.gender = gender
        self.status = status
        self.loginuser_name = loginuser_name
        self.relationship = relationship
        self.age = age
        self.appoint_date = appoint_date
        self.appoint_start_time = appoint_start_time
        self.appoint_end_time = appoint_end_time
        self.appointment_type = appointment_type
        self.description = description

    }
    
}


