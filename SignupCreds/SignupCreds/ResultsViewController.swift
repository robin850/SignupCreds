//
//  SecondViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ResultsViewController : UIViewController, BaseController {
    @IBOutlet weak var alertButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setModalButtonStyle(button: self.alertButton)
        
        let controller = self.tabBarController! as! BarController
        
        let users = UserDefaults.standard.array(forKey: serviceName(index: controller.service!))!
        for user in users {
            for  (key, value) in user as! [String: String] {
                print("\(key) : \(value)")
            }
        }
    }
    
    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }
}
