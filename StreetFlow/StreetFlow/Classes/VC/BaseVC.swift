//
//  BaseVC.swift
//  StreetFlow
//
//  Created by Alex on 3/13/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
