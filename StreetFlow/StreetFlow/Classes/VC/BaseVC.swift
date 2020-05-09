//
//  BaseVC.swift
//  StreetFlow
//
//  Created by Alex on 3/13/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateFullname(_ name: String) -> String {
//        var nameStr = name.replacingOccurrences(of: ";", with: ", ")
        let nameAry = name.components(separatedBy: ";")
        var newAry: [String] = []
        for name in nameAry {
            var components = name.components(separatedBy: " ")
            if components.count > 0 {
                 let lastName = components.removeFirst()
                 let firstName = components.joined(separator: " ")
                 let newName = firstName + " " + lastName
//                 print(newName)
                newAry.append(newName)
            }
        }
        let newStr = newAry.joined(separator: ", ")
        print(newStr)
        return newStr
    }
    
    @objc
    func tapForgotLabel(gesture: UITapGestureRecognizer) {
        print("Tapped forgot label")
    }
    
    @objc
    func tapTermsLabel(gesture: UITapGestureRecognizer) {
        print("Tapped terms label")
    }
    
    func goNextVCWithID(_ storyboardId: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popNextVCWithID(_ storyboardId: String, isFull: Bool) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId)
        if isFull {
            vc.modalPresentationStyle = .fullScreen
        }        
        self.present(vc, animated: true, completion: nil)
    }
    
    func backVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getEstatedInfo(_ address: String, completion: @escaping (_ flag: Bool, _ result: String) ->()) {
        let baseUrl = "https://apis.estated.com/v4/property?token=p1w0ToQ4IddhvDSQgaR37WDy7PWmxV&combined_address="
        let urlStr = baseUrl + address
        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(urlString!)
        
        let url = URL(string:urlString!)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
            if let data = data {
//                print("Response data string:\n \(dataString)")
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                        print(convertedJsonIntoDict)
                        es_data = convertedJsonIntoDict
                        if es_data != nil {
                             if let warnings = es_data["warnings"] as? Array<Any> {
                                if let wf = warnings.first as? NSDictionary {
                                    if let description = wf["description"] as? String {
                                     completion(false, description)
                                    }
                                } else {
                                   completion(true, "")
                                }
                             } else if let err = es_data["error"] as? NSDictionary {
                                    if let description = err["description"] as? String {
                                        completion(false, description)
                                    }else {
                                        completion(true, "")
                                    }
                             } else {
                                completion(true, "")
                            }
                        }
                        
                   }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
            }
        }

        task.resume()
    }
    
    func getbasicInfo() -> [String : String?] {
        if es_data != nil {
             if let data = es_data["data"] as? NSDictionary {
               if let owner = data["owner"] as? NSDictionary {
                return owner as! [String : String?]
               }
            }
        }
        return ["name": ""]
    }

}

extension UIView {
    func addShadowEffect() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
}
