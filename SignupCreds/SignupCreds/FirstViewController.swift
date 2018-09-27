//
//  FirstViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var service : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
        service = 0
        
        do {
            let data = try Data(contentsOf: jsonPath!)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            let jsonServices = json as! [String : Any]
            let services     = jsonServices["services"] as! Array<[String: Any]>
            
            let dataService = services[service!]
            
            for element in dataService["elements"] as! Array<[String : Any]> {
                print(element["section"] as! String)
                print(element["type"] as! String)
                
                let values = element["value"] as! Array<String>
                for valeur in values {
                    print(valeur)
                }
                
                print("---------------------")
            }
        } catch {
            print(error)
        }
    }
}

