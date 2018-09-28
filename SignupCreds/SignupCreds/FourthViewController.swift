//
//  FourthViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FourthViewController : UIViewController {
    
    @IBOutlet weak var alertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        self.alertButton.backgroundColor = .clear
        self.alertButton.layer.cornerRadius = 15
        self.alertButton.layer.borderWidth = 1
        self.alertButton.layer.borderColor = appleBlue.cgColor
        // Do any additional setup after loading the view, typically from a nib.
    }
}
