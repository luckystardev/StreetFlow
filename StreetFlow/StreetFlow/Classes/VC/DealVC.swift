//
//  DealVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class DealVC: BaseVC {
    
    @IBOutlet weak var selectLocationView: RoundView!
    @IBOutlet weak var bottomMenuBtn: UIButton!
    
    //owner property
    @IBOutlet weak var owner_name: UILabel!
    @IBOutlet weak var owner_street: UILabel!
    @IBOutlet weak var owner_address: UILabel!
    //sale property
    @IBOutlet weak var sale_date: UILabel!
    @IBOutlet weak var sale_price: UILabel!
    //mortgage information
    @IBOutlet weak var mort_date: UILabel! // amount
    @IBOutlet weak var mort_price: UILabel! // leander name
    @IBOutlet weak var mort_assessedVale: UILabel!
    //property info
    @IBOutlet weak var property_improve: UILabel!
    @IBOutlet weak var property_land: UILabel!
    @IBOutlet weak var property_total: UILabel!
    @IBOutlet weak var property_datebulit: UILabel!
    @IBOutlet weak var property_square: UILabel!
    @IBOutlet weak var property_acreage: UILabel!
    //school district
    @IBOutlet weak var school_district: UILabel!
    //offer sent
    @IBOutlet weak var offerSent_type: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectLocationView.addShadowEffect()
        bottomMenuBtn.addShadowEffect()
        
        if es_data != nil {
             //need to update
             school_district.text = "unknown"
             mort_assessedVale.text = "unknown"
            
             if let data = es_data["data"] as? NSDictionary {
                if let owner = data["owner"] as? NSDictionary {
                    owner_name.text = owner["name"] as? String
                    owner_street.text = owner["formatted_street_address"] as? String
                    let city : String = owner["city"] as? String ?? ""
                    let state : String = owner["state"] as? String ?? ""
                    let zip_code : String = owner["zip_code"] as? String ?? ""
                    let address : String = city + "," + state + " " + zip_code
                    owner_address.text = address
                }
                if let assessments = data["assessments"] as? Array<Any> {
                    if let property = assessments.first as? NSDictionary {
                        property_improve.text = "$\(String(describing: property["improvement_value"]!))"
                        property_land.text = "$\(String(describing: property["land_value"]!))"
                        property_total.text = "$\(String(describing: property["total_value"]!))"
                    }
                }
                if let structure = data["structure"] as? NSDictionary {
                    property_datebulit.text = "\(String(describing: structure["year_built"]!))"
//                    property_square.text = "$\(String(describing: structure["total_area_sq_ft"]!))"
                }
                if let parcel = data["parcel"] as? NSDictionary {
                    property_square.text = "\(String(describing: parcel["area_sq_ft"]!))"
                    property_acreage.text = "\(String(describing: parcel["area_acres"]!))"
                }
                if let deeds = data["deeds"] as? Array<Any> {
                    if let deedf = deeds.first as? NSDictionary {
                        sale_date.text = deedf["recording_date"] as? String
                        sale_price.text = "$\(String(describing: deedf["sale_price"]!))"
                    }
                    if let deedl = deeds.last as? NSDictionary {
                        mort_date.text = "$\(String(describing: deedl["loan_amount"]!))"
                        mort_price.text = deedl["lender_name"] as? String                       
                    }
                }
            }
        }
    }
    
    @IBAction func downBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
