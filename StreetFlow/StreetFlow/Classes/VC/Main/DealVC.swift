//
//  DealVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import TaggerKit
import JGProgressHUD

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
    @IBOutlet weak var offer_type: UILabel!
    @IBOutlet weak var offer_detail: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tagView: RoundView!
    
    @IBOutlet weak var tagContainer: UIView!
    @IBOutlet weak var addTagView: UIView!
    @IBOutlet var addTagsTextField : TKTextField!
    @IBOutlet var searchContainer : UIView!
    
    var productTags: TKCollectionView!
    var allTags: TKCollectionView!
    
    let phoneFieldTag = 1000
    var detailDic: [String: String]! = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectLocationView.addShadowEffect()
        bottomMenuBtn.addShadowEffect()
        
        initTags()
        
//        initESData()
        initPPData()
    }
    
    func initPPData() {
        if let owner = pp_data["owner_property"]! as? [String: String] {
            owner_name.text = owner["owner"]!
            owner_street.text = owner["property_label"]!
            owner_address.text = owner["address"]!
        }
        
        if let sales = pp_data["sale_info"]! as? [String: Any] {
            let saleDate = sales["date"]! as? String
            sale_date.text = formattedDateFromString(dateString: saleDate!, withFormat: "MMM dd, yyyy")!
            sale_price.text = "\(sales["price"]!)"
        }
        
        if let mort = pp_data["mort_info"]! as? [String: Any] {
            mort_price.text = mort["name"]! as? String
            mort_date.text = "\(mort["amount"]!)"
            mort_assessedVale.text = "\(mort["value"]!)"
        }
        
        property_improve.text = "\(pp_data["improvement_value"]!)"
        property_land.text = "\(pp_data["land_value"]!)"
        property_total.text = "\(pp_data["total_value"]!)"
        property_datebulit.text = "\(pp_data["year"]!)"
        property_square.text = "\(pp_data["square_footage"]!)"
        property_acreage.text = "\(pp_data["acreage"]!)"
        
        if let dist = pp_data["dist_info"]! as? [String: Any] {
            school_district.text = dist["school_district"]! as? String
        }
        
        if let ownerDetails = pp_data["owner_details"]! as? [String: String] {
            detailDic = ownerDetails
            emailLbl.text = ownerDetails["email"]!
            phoneLbl.text = ownerDetails["phone"]!
        }
        
        if let tags = pp_data["property_tags"]! as? Array<String> {
            if tags.count == 0 {
                print("tag empty")
            } else {
                print("tag isn't empty")
                updateTags(tags)
            }
        }
        
    }
    
    func updateTags(_ tags: Array<String>) {
        productTags = TKCollectionView(tags: tags,
                                       action: .removeTag,
                                       receiver: nil)
        
        add(productTags, toView: tagContainer)
    }
    
    func updateTagData() {
        pp_data["property_tags"] = productTags.tags
        updateProperty()
    }
    
    func initESData() {
        if es_data != nil {
             //need to update
             school_district.text = "unknown"
             mort_assessedVale.text = "unknown"
            
             if let data = es_data["data"] as? NSDictionary {
                if let owner = data["owner"] as? NSDictionary {
                    let ownerStr = owner["name"] as? String
                    owner_name.text = updateFullname(ownerStr!)
                    owner_street.text = owner["formatted_street_address"] as? String
                    let city : String = owner["city"] as? String ?? ""
                    let state : String = owner["state"] as? String ?? ""
                    let zip_code : String = owner["zip_code"] as? String ?? ""
                    let address : String = city + ", " + state + " " + zip_code
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
    
    func initTags() {
        addTagView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        addTagView.layer.borderWidth = 1.0
        addTagView.isHidden = true
        
        addTagsTextField.backgroundColor = UIColor.clear
        addTagsTextField.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.5098039216, blue: 0.631372549, alpha: 1)
        addTagsTextField.layer.borderWidth = 1.0
        addTagsTextField.layer.cornerRadius = 6
        
        productTags = TKCollectionView(tags: [],
                                       action: .removeTag,
                                       receiver: nil)
        
        allTags = TKCollectionView(tags: [],
                                   action: .addTag,
                                   receiver: productTags)
        
        productTags.customFont = UIFont(name: "CircularStd-Book", size: 12)!
        allTags.customFont = UIFont(name: "CircularStd-Book", size: 12)!
        productTags.customBackgroundColor = #colorLiteral(red: 0.4078431373, green: 0.5098039216, blue: 0.631372549, alpha: 1)
        allTags.customBackgroundColor = #colorLiteral(red: 0.4078431373, green: 0.5098039216, blue: 0.631372549, alpha: 1)
        
        // Set the current controller as the delegate of both collections
        productTags.delegate = self
        allTags.delegate = self
        
        // Set the sender and receiver of the TextField
        addTagsTextField.sender     = allTags
        addTagsTextField.receiver     = productTags
        
        add(productTags, toView: tagContainer)
        add(allTags, toView: searchContainer)
    }
    
    @IBAction func downBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func removePropertyAction(_ sender: Any) {
        
    }
    
    func updateProperty() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        print(pp_data!)
        let webService =  RestAPIManager.sharedManager
        webService?.updateProperty(pp_data, callback: { (responseObject:NSDictionary?, error:NSError?) in
            hud.dismiss()
            if((error) != nil){ //error
                if let descrip = error?.localizedDescription{
                    self.showErrorAlert(title: descrip)
                }
            }else{ //success
                let hud2 = JGProgressHUD(style: .dark)
                hud2.textLabel.text = "Saved!"
                hud2.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud2.show(in: self.view)
                hud2.dismiss(afterDelay: 1.5)
            }
        })
    }
    
    @IBAction func closeTagViewAction(_ sender: Any) {
        addTagView.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func ManageTagsAction(_ sender: Any) {
        addTagView.isHidden = false
    }
    
    @IBAction func offerChangeAction(_ sender: Any) {
        let str1 = "Not Connected Yet"
        let str2 = "Contacted Owner"
        let str3 = "Offer Sent"
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: str1, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.offer_type.text = str1
        })
        let secondAction = UIAlertAction(title: str2, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.offer_type.text = str2
        })
        let thirdAction = UIAlertAction(title: str3, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.offer_type.text = str3
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(firstAction)
        optionMenu.addAction(secondAction)
        optionMenu.addAction(thirdAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func addPhoneAction(_ sender: Any) {
        let placeTxt = "+ Add Phone Number"
        let ac = UIAlertController(title: "Enter Phone number", message: nil, preferredStyle: .alert)
        ac.addTextField() { newTextField in
            newTextField.keyboardType = .numberPad
            newTextField.placeholder = "Enter Phone Number"
            newTextField.tag = self.phoneFieldTag
            newTextField.delegate = self
            
            if self.phoneLbl.text != placeTxt && self.phoneLbl.text != "" && self.phoneLbl.text != nil {
                newTextField.text = self.phoneLbl.text!.replacingOccurrences(of: "-", with: "")
            }
        }
        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            // do something interesting with "answer" here
            let formattedPhone = self.format(phoneNumber: answer.text!)
            if formattedPhone == "" || formattedPhone == nil {
                self.phoneLbl.text = placeTxt
            } else {
                self.phoneLbl.text = formattedPhone
                
                self.detailDic["phone"] = self.phoneLbl.text
                pp_data["owner_details"] = self.detailDic
                self.updateProperty()
            }
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func addEmailAction(_ sender: Any) {
        let placeTxt = "+ Add Email Address"
        let ac = UIAlertController(title: "Enter Email Address", message: nil, preferredStyle: .alert)
        ac.addTextField() { newTextField in
            newTextField.keyboardType = .emailAddress
            newTextField.placeholder = "Enter Email Address"
            if self.emailLbl.text != placeTxt {
                newTextField.text = self.emailLbl.text
            }
        }
        let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            // do something interesting with "answer" here
            if self.emailLbl.text != "" {
                self.emailLbl.text = answer.text
                
                self.detailDic["email"] = self.emailLbl.text
                pp_data["owner_details"] = self.detailDic
                self.updateProperty()
            }
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")

        // Check for supported phone number length
//        guard length == 7 || (length == 10 && !hasLeadingOne) || (length == 11 && hasLeadingOne) else {
//            return nil
//        }

        let hasAreaCode = (length >= 10)
        var sourceIndex = 0

        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = ""
            sourceIndex += 1
        }

        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "%@-", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }

        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength

        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }

        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
}

extension DealVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == phoneFieldTag {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 11
        }
        return true
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }

        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }

        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

extension DealVC: TKCollectionViewDelegate {

    func tagIsBeingAdded(name: String?) {
        // Example: save testCollection.tags to UserDefault
        print("added \(name!)")
        updateTagData()
    }
    
    func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
        updateTagData()
    }
    
}
