//
//  GetScheduledAppointmentDataEntity.swift
//  SureShow
//
//  Created by apple on 13/12/21.
//

import Foundation
//{
//    "status": 200,
//    "message": "Data found successfully",
//    "data": [
//        {
//            "id": 58,
//            "appointment_title": "Test appointment",
//            "patient_type": 1,
//            "appointment_type": 1,
//            "doctor_id": 6,
//            "doctor_name": "komal arya",
//            "disease": "Diabetes",
//            "appoint_start_time": "10 AM",
//            "appoint_end_time": "11 AM",
//            "appoint_date": "2022-11-28",
//            "description": "This is test "
//        }
//    ]
//}


struct GetScheduledAppointmentData<T>{
    
    
    
    var status: Int
    var message: String
    var addAppointmentListArray:[ScheduledAppointmentListData<T>]
    
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataArr = dict["data"] as? [[String:T]] ?? [[:]]
        
        self.status = status
        self.message = alertMessage
        var hArray = [ScheduledAppointmentListData<T>]()
        for obj in dataArr{
            let childListObj = ScheduledAppointmentListData(dataDict:obj)!
            hArray.append(childListObj)
        }
        self.addAppointmentListArray = hArray
    }
}


struct ScheduledAppointmentListData<T>{
    var id:Int
    var appointment_title:String
    var patient_type:Int
    var appointment_type:String
    var doctor_id:String
    var doctor_name:String
    var disease:String
    var appoint_date:String
    var appoint_start_time:String
    var appoint_end_time:String
    var description:String

    
    
    init?(dataDict:[String:T]) {
        
        let id = dataDict["id"] as? Int ?? 0
        let appointment_title = dataDict["appointment_title"] as? String ?? ""
        let patient_type = dataDict["patient_type"] as? Int ?? 0
        let appointment_type = dataDict["appointment_type"] as? String ?? ""
        let doctor_id = dataDict["doctor_id"] as? String ?? ""
        let doctor_name = dataDict["doctor_name"] as? String ?? ""
        let disease = dataDict["disease"] as? String ?? ""
        let appoint_date = dataDict["appoint_date"] as? String ?? ""
        let appoint_start_time = dataDict["appoint_start_time"] as? String ?? ""
        let appoint_end_time = dataDict["appoint_end_time"] as? String ?? ""
        let description = dataDict["description"] as? String ?? ""

        
        
        self.id = id
        self.appointment_title = appointment_title
        self.patient_type = patient_type
        self.appointment_type = appointment_type
        self.doctor_id = doctor_id
        self.doctor_name = doctor_name
        self.disease = disease
        self.appoint_date = appoint_date
        self.appoint_start_time = appoint_start_time
        self.appoint_end_time = appoint_end_time
        self.description = description

    }
    
}


