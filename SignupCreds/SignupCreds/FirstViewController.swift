//
//  FirstViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit
import Eureka

class FirstViewController: FormViewController, BaseController {
    //var service : Int?
    
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var defaultFormView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setModalButtonStyle(button: alertButton)

        //defaultFormView.isHidden = true
        
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
        
        form +++ Section("info")
            <<< TextRow(){ row in
                row.title = "Nom"
                row.placeholder = "Votre nom"
            }
            <<< TextRow(){ row in
                row.title = "Prénom"
                row.placeholder = "Votre prénom"
            }
            <<< SegmentedRow<String>() {
               //  $0.title = "Sexe"
               // $0.selectorTitle = "Genre"
                $0.options = ["Homme","Femme"]
                $0.value = "Homme"    // initially selected
        }
            <<< TextRow(){ row in
                row.title = "Ville"
                row.placeholder = "Votre ville"
        }
            form +++ Section("abonnement")
            <<< LabelRow { row in
                row.title = "Abonnement"
                row.cell.textLabel?.numberOfLines = 0
        }
            <<< SegmentedRow<String>() {
                //  $0.title = "Sexe"
                // $0.selectorTitle = "Genre"
                $0.options = ["3 mois","6 mois", "1 ans"]
                $0.value = "6 mois"    // initially selected
        }
            form +++ Section("newsletter")
            <<< LabelRow { row in
                row.title = "Newsletter"
                row.cell.textLabel?.numberOfLines = 0
        }
            <<< SwitchRow("switchRowTag"){
                $0.title = "Newsletter"
        }
    
        
        
        //service = 0
        
        //do {
            //let data = try Data(contentsOf: jsonPath!)
            //let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            //let jsonServices = json as! [String : Any]
            //let services     = jsonServices["services"] as! Array<[String: Any]>
            
            //let dataService = services[service!]
            //var y = 0
            //for title in jsonServices["services"] as! Array<[String: Any]> {
                //for element in title["elements"] as! Array<[String : Any]> {
                    //print(element["section"] as! String)
                    //print(element["type"] as! String)

                    //let values = element["value"] as! Array<String>
                    //for valeur in values {
                        //print(valeur)
                        //let label = UILabel(frame: CGRect(x: 16, y: y, width: 300, height: 21))
                        //label.text = valeur
                        //label.textColor = UIColor.black
                        //self.scrollView.addSubview(label)
                        //y += 30
                    //}
                //}
           // }
        //} catch {
           // print(error)
        //}
    }

    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }
}

