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
        
        var userDict = [String:Any]()
        var userArray = [Any]()
        
        userDict = [:]
        userDict.updateValue("Ta grand mere", forKey: "username")
        userDict.updateValue("lol@lol.fr", forKey: "email")
        userDict.updateValue("jemangeducaca", forKey: "password")
        userArray.append(userDict)
        
        UserDefaults.standard.set(userArray, forKey: "netflix")
        
        for element in userArray {
            print(element)
        }
        
        UserDefaults.standard.array(forKey: "netflix")
        
    }

    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }
}
