//
//  ThirdViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ThirdViewController : UIViewController {
    
    @IBOutlet weak var spotifyService: UIImageView!
    @IBOutlet weak var netflixService: UIImageView!
    @IBOutlet weak var alertButton: UIButton!
    let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertButton.backgroundColor = .clear
        self.alertButton.layer.cornerRadius = 15
        self.alertButton.layer.borderWidth = 1
        self.alertButton.layer.borderColor = appleBlue.cgColor
        
        self.netflixService.layer.shadowColor = UIColor.black.cgColor
        self.netflixService.layer.shadowOpacity = 0.1
        self.netflixService.layer.shadowRadius = 15
        self.netflixService.layer.shadowPath = UIBezierPath(rect: netflixService.bounds).cgPath
        self.netflixService.layer.shouldRasterize = false
        
        self.spotifyService.layer.shadowColor = UIColor.black.cgColor
        self.spotifyService.layer.shadowOpacity = 0.1
        self.spotifyService.layer.shadowRadius = 15
        self.spotifyService.layer.shadowPath = UIBezierPath(rect: spotifyService.bounds).cgPath
        self.spotifyService.layer.shouldRasterize = false
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}
