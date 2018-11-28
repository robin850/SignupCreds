//
//  BarController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 12/11/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import Foundation
import UIKit

class BarController : UITabBarController {
    public var service : Int? {
        didSet {
            let controller = self.viewControllers![1] as! FormViewController

            self.selectedIndex = 1
            controller.generateForm(service: self.service!)
        }
    }

    public var services : Array<[String:Any]> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        right.direction = .right
        self.view.addGestureRecognizer(right)

        // Chargement des services
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
        let data = try! Data(contentsOf: jsonPath!)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let jsonServices = json as! [String : Any]

        self.services = jsonServices["services"] as! Array<[String: Any]>
    }
    
    @objc func swipeLeft() {
        let total = self.viewControllers!.count - 1
        self.selectedIndex = min(total, self.selectedIndex + 1)
        
    }
    
    @objc func swipeRight() {
        self.selectedIndex = max(0, self.selectedIndex - 1)
    }
}
