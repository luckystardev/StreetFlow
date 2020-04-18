//
//  PageVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import MASegmentedControl
import SwiftyPageController

class PageVC: BaseVC {

    var containerController: SwiftyPageController!
    
    @IBOutlet weak var selectLocationView: RoundView!
    @IBOutlet weak var bottomMenuBtn: UIButton!
    @IBOutlet weak var selectLocationFld: UITextField!
    @IBOutlet weak var topMenuBtn: UIButton!
    
    @IBOutlet weak var viewTypeSegment: MASegmentedControl!{
        didSet {
            //Set this booleans to adapt control
            viewTypeSegment.itemsWithText = true
            viewTypeSegment.fillEqually = true
            viewTypeSegment.roundedControl = true
            
            let strings = ["Map View", "List View"]
            viewTypeSegment.setSegmentedWith(items: strings)
            viewTypeSegment.padding = 2
            viewTypeSegment.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            viewTypeSegment.selectedTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            viewTypeSegment.thumbViewColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            viewTypeSegment.titlesFont = UIFont(name: "CircularStd-Bold", size: 14)
            viewTypeSegment.segmentedBackGroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6980950342)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectLocationView.addShadowEffect()
        bottomMenuBtn.addShadowEffect()
        topMenuBtn.addShadowEffect()
        viewTypeSegment.addShadowEffect()
    }
    
    @IBAction func segmentChanged(_ sender: MASegmentedControl) {
        containerController.selectController(atIndex: sender.selectedSegmentIndex, animated: true)
    }
    
    func setupContainerController(_ controller: SwiftyPageController) {
        // assign variable
        containerController = controller
        
        // set delegate
        containerController.delegate = self
        
        // set animation type
        containerController.animator = .parallax
        
        // set view controllers
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListVC")
        containerController.viewControllers = [firstVC, secondVC]
        
        // select needed controller
        containerController.selectController(atIndex: 0, animated: false)
    }
    
    @IBAction func topMenuBtnAction(_ sender: UIButton) {
        /*
        let url = URL(string: "https://apis.estated.com/v4/property?token=cyoidbzD1vn0HwQsykSFLvLXKWVmFU&combined_address=151%20Battle%20Green%20Dr,%20Rochester,%20NY%2014624")

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
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }

        task.resume() */
    }
    
    @IBAction func touchLocationFld(_ sender: Any) {
        print("touchLocationFld")
//        goNextVCWithID("SearchVC")
        popNextVCWithID("SearchVC", isFull: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let containerController = segue.destination as? SwiftyPageController {
            setupContainerController(containerController)
        }
    }

}

// MARK: - PagesViewControllerDelegate

extension PageVC: SwiftyPageControllerDelegate {
    
    func swiftyPageController(_ controller: SwiftyPageController, alongSideTransitionToController toController: UIViewController) {
        
    }
    
    func swiftyPageController(_ controller: SwiftyPageController, didMoveToController toController: UIViewController) {
        
    }
    
    func swiftyPageController(_ controller: SwiftyPageController, willMoveToController toController: UIViewController) {
        
    }
}
