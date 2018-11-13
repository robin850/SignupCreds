//
//  FirstViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, BaseController {
    //var service : Int?
    
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var scrollView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setModalButtonStyle(button: alertButton)
        
        /* Génération dynamique de la vue */
        generateForm(service: -1)
        
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

    func generateForm(service: Int) {
        
        /* Récupération du fichier JSON */
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
        let data = try! Data(contentsOf: jsonPath!)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let jsonServices = json as! [String : Any]
        let services     = jsonServices["services"] as! Array<[String: Any]>
        
        /* Création d'un label pour indiquer à l'utilisateur de faire un choix de service */
        if(service == -1) {
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.scrollView.frame.width - 16, height: 100))
            label.text = "Vous n'avez pas sélectionné de service. Veuillez vous rendre dans l'onglet Services s'il vous plait."
            label.textColor = UIColor.black
            label.numberOfLines = 0
            self.scrollView.addSubview(label)
        }
        
        /* Génération du formulaire */
        
    }
}

