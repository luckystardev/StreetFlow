//
//  MenuVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import Parse

class MenuVC: BaseVC {

    @IBOutlet weak var selectLocationView: RoundView!
    @IBOutlet weak var bottomCloseBtn: UIButton!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var firstnameLbl: UITextField!
    @IBOutlet weak var lastnameLbl: UITextField!
    @IBOutlet weak var phoneLbl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectLocationView.addShadowEffect()
        bottomCloseBtn.addShadowEffect()
        
//        let user = PFUser.current()
//        let fname = user!["first_name"] as! String
//        let lname = user!["last_name"] as! String
//        let phone = user!["phone"] as? String
//        fullnameLbl.text = fname + " " + lname
//        firstnameLbl.text = fname
//        lastnameLbl.text = lname
//        phoneLbl.text = phone
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
//        PFUser.logOut()
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstVC")
        UIApplication.shared.windows.first?.rootViewController = firstVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
