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
        self.netflixService.layer.cornerRadius = 15
        self.netflixService.clipsToBounds = true
        
        
        self.spotifyService.layer.shadowColor = UIColor.black.cgColor
        self.spotifyService.layer.shadowOpacity = 0.1
        self.spotifyService.layer.shadowRadius = 15
        self.spotifyService.layer.shadowPath = UIBezierPath(rect: spotifyService.bounds).cgPath
        self.spotifyService.layer.shouldRasterize = false
        
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
        var y = 139
        
        do {
            let data = try Data(contentsOf: jsonPath!)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            let jsonServices = json as! [String : Any]
            
            for title in jsonServices["services"] as! Array<[String: Any]> {
                for element in title["elements"] as! Array<[String : Any]> {
                    let section = element["section"] as! String
                    
                    if(section == "title") {
                        let values = element["value"] as! Array<String>
                        for valeur in values {
                            let myLabel:UILabel = UILabel(frame: CGRect(x : 16, y : y, width: 343, height: 21))
                            myLabel.text = valeur
                            myLabel.textColor = UIColor.black
                            self.view.addSubview(myLabel)
                            y += 61
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}
