//
//  RestAPIManager.swift
//  StreetFlow
//
//  Created by Alex on 7/9/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RestAPIManager: NSObject {
    let main_url = "https://develop-api.sf.climbings.scheria.org/"
    static var sharedManager: RestAPIManager! = RestAPIManager();
    typealias ServiceResponse = (NSDictionary?, NSError?) -> Void
    typealias ServiceArrayResponse = (Array<Any>?, NSError?) -> Void
    //***********************************************************//
    //Auth APIs
    //***********************************************************//
    
    func login(_ username: String, password: String, callback:@escaping(ServiceResponse)) {
        
        let url = URL(string: main_url + "auth/jwt/login")!
        let params = ["username": username, "password": password]
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                if let value = value as? [String: Any] {
                    print(value["access_token"] as! String)
                    access_token = (value["access_token"] as! String)
                    callback(value as NSDictionary, nil)
                    return
                }
//                else {
//                     let error: Error? = NSError(domain:"", code:1, userInfo:nil)
//                    callback(nil, error as NSError?)
//                }
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
    
    func register(_ dic: [String: Any], callback:@escaping(ServiceResponse)) {
            
        let url = URL(string: main_url + "auth/register")!
//        let headers:HTTPHeaders = ["Content-Type":"text/plain", "Authorization":"application/json"]
        AF.request(url, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                if let value = value as? [String: Any] {
                    callback(value as NSDictionary, nil)
                    return
                }
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
    
    func forgotPassword(_ email: String, callback:@escaping(ServiceResponse)) {
        let url = URL(string: main_url + "auth/forgot-password")!
        let params = ["email": email]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(_):
                callback(nil, nil)
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
    
    //***********************************************************//
    // User APIs
    //***********************************************************//
    func getUserInfo(callback:@escaping(ServiceResponse)) {
        let url = URL(string: main_url + "users/me")!
        let headers:HTTPHeaders = ["Authorization":"Bearer \(access_token!)"]
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                if let value = value as? [String: Any] {
                    callback(value as NSDictionary, nil)
                    return
                }
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
    
    //***********************************************************//
    // Property APIs
    //***********************************************************//
    
    func readAllProperties(callback:@escaping(ServiceArrayResponse)) {
        let url = URL(string: main_url + "properties/readAll/\(userId!)")!
        let headers:HTTPHeaders = ["Authorization":"Bearer \(access_token!)"]
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                if let value = value as? Array<Any> {
                    callback(value, nil)
                    return
                }
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
    
    func updateProperty(_ dic: [String: Any], callback:@escaping(ServiceResponse)) {
        let url = URL(string: main_url + "properties/update")!
        let headers:HTTPHeaders = ["Authorization":"Bearer \(access_token!)"]
        AF.request(url, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                if let value = value as? [String: Any] {
                    callback(value as NSDictionary, nil)
                    return
                }
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
    
    func createProperty(_ dic: [String: Any], callback:@escaping(ServiceResponse)) {
        let url = URL(string: main_url + "properties/create")!
        let headers:HTTPHeaders = ["Authorization":"Bearer \(access_token!)"]
        AF.request(url, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                if let value = value as? [String: Any] {
                    callback(value as NSDictionary, nil)
                    return
                }
                break
            case .failure(let error):
                print("error!!!- \(error.localizedDescription)")
                callback(nil, error as NSError)
                break
            }
        }
    }
}
