//
//  MenuVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class MenuVC: BaseVC {

    @IBOutlet weak var selectLocationView: RoundView!
    @IBOutlet weak var bottomCloseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectLocationView.addShadowEffect()
        bottomCloseBtn.addShadowEffect()
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstVC")
        UIApplication.shared.windows.first?.rootViewController = firstVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
