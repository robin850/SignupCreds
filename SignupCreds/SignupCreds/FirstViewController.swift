//
//  FirstViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit
import Eureka

class FirstViewController: FormViewController {
    //var service : Int?
    
    @IBOutlet weak var alertButton: UIButton!
   // Popup avec infos système
    @IBAction func buttonClick(_ sender: UIButton) {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }
        
        var x = ""
        if kerr == KERN_SUCCESS {
            x = ("Memory in use (in bytes): \(info.resident_size)")
        }
        else {
            x = "Error with task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error")
        }
        let alertController = UIAlertController(title: "Infos Système", message: x, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var defaultFormView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultFormView.isHidden = true
        let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        self.alertButton.backgroundColor = .clear
        self.alertButton.layer.cornerRadius = 15
        self.alertButton.layer.borderWidth = 1
        self.alertButton.layer.borderColor = appleBlue.cgColor
        
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
}

