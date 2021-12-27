//
//  GetAppointmentTypeListEntity.swift
//  SureShow
//
//  Created by apple on 14/12/21.
//

import Foundation

//{
//    "status": 200,
//    "message": "Data found successfully",
//    "data": [
//        {
//            "id": 1,
//            "name": "Clinic",
//            "created_at": "2021-12-14 06:56:25",
//            "updated_at": null
//        },
//        {
//            "id": 2,
//            "name": "Telehealth",
//            "created_at": "2021-12-14 06:56:25",
//            "updated_at": null
//        },
//        {
//            "id": 3,
//            "name": "Dental Van",
//            "created_at": "2021-12-14 06:58:33",
//            "updated_at": null
//        },
//        {
//            "id": 4,
//            "name": "Mobile Dental Clinic",
//            "created_at": "2021-12-14 06:58:33",
//            "updated_at": null
//        }
//    ]
//}

struct GetAppointmentTypeData<T>{
    
    var status: Int
    var message: String
    var getAppointmentTypeListArray:[AppointmentTypeListData<T>]
    
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataArr = dict["data"] as? [[String:T]] ?? [[:]]
        
        self.status = status
        self.message = alertMessage
        var hArray = [AppointmentTypeListData<T>]()
        for obj in dataArr{
            let childListObj = AppointmentTypeListData(dataDict:obj)!
            hArray.append(childListObj)
        }
        self.getAppointmentTypeListArray = hArray
    }
}

struct AppointmentTypeListData<T>{
    var id:Int
    var name:String
    var created_at:String
    var updated_at:String

    init?(dataDict:[String:T]) {
        
        let id = dataDict["id"] as? Int ?? 0
        let name = dataDict["name"] as? String ?? ""
        let created_at = dataDict["created_at"] as? String ?? ""
        let updated_at = dataDict["updated_at"] as? String ?? ""

        self.id = id
        self.name = name
        self.created_at = created_at
        self.updated_at = updated_at

    }
    
}
