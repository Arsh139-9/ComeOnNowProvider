//
//  AppMultipleApisModal.swift
//  SureShow
//
//  Created by Apple on 14/10/21.
//

import Foundation
import Alamofire

class ModalResponse{
    
    open func getPatientListApi(onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getPatientList, params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func getHospitalListApi(onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getClinicList, params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func getBranchListApi(clinicId:Int,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getBranchList + "?clinic_id=\(clinicId)", params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func getProviderListApi(clinicId:Int,branchId:Int,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        //branch_id=3&clinic_id=1
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getProviderList + "?branch_id=\(branchId)&clinic_id=\(clinicId)", params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func getAppointmentListApi(perPage:Int,page:Int,status:Int,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        //per-page=20&page=1&status=2
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getAppointmentList + "?per-page=\(perPage)&page=\(page)&status=\(status)", params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    
    open func getAppointmentTypeApi(onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        //branch_id=3&clinic_id=1
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getAppointmentTypesList , params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func getDiseaseListApi(onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getDiseaseList, params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    public func getAppointmentHistoryListApi(perPage:Int,page:Int,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getAppointmentHistoryList +  "?per-page=\(perPage)&page=\(page)", params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    public func getScheduledAppointmentListApi(perPage:Int,page:Int,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getAppointmentScheduleList +  "?per-page=\(perPage)&page=\(page)", params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func addQueueListApi(params:[String : Any]?,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.addGetQueueList, params:params, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func addScheduledAppointmentListApi(params:[String : Any]?,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestPostWithMultiFormData(kBASEURL + WSMethods.getAppointmentScheduleList, params:params, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    open func getNotificationListApi(perPage:Int,page:Int,onSuccess success: @escaping ([String:AnyObject]) -> Void, onFailure failure: @escaping (Error) -> Void) {
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)]
        
        AFWrapperClass.requestGETURL(kBASEURL + WSMethods.getNotificationList + "?per-page=\(perPage)&page=\(page)", params:nil, headers:headers) { response in
            let result = response as AnyObject
            print(result)
            if let json = result as? [String:AnyObject] {
                success(json as [String:AnyObject])
            }
        } failure: { error in
            
            failure(error)
        }
        
    }
    
}

