//
//  ListVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class ListVC: BaseVC {
    
    @IBOutlet weak var tableview: UITableView!
    var info: [String : String?]?
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        info = getbasicInfo()
        if info?["name"] != "" {
            num = 1
            self.tableview.reloadData()
        }        
    }

}

extension ListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        let ownerStr = info?["name"] ?? ""
        cell.nameLbl.text = updateFullname(ownerStr!)
        cell.streetLbl.text = info?["formatted_street_address"] ?? ""
        let city : String = (info?["city"] ?? "") ?? " "
        let state : String = (info?["state"] ?? "") ?? " "
        let zip_code : String = (info?["zip_code"] ?? "") ?? " "
        let address : String = city + ", " + state + " " + zip_code
        cell.addressLbl.text = address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popNextVCWithID("DealVC", isFull: false)
    }
    
}
