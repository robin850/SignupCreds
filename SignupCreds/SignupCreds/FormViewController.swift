//
//  FirstViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, BaseController {
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
        
        /* Position des éléments dans la vue */
        var y : CGFloat
        y = 0
        
        /* Marge à placer pour passer à la catégorie suivante */
        var marginBottom : CGFloat
        marginBottom = 20
        
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
            label.font = UIFont.systemFont(ofSize: 17.0)
            self.scrollView.addSubview(label)
            y += label.frame.height + marginBottom
        }
        
        /* Génération du formulaire */
        
        
        /* Génération du bouton de validation */
        let button = UIButton(frame: CGRect(x: 16, y: y, width: self.scrollView.frame.width - 16, height: 50))
        button.setTitle("Enregistrer", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(FormViewController.buttonAction(_:)), for: .touchUpInside)
        self.scrollView.addSubview(button)
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        
        print("Ca marche")
    }
    
    /* Retourne tous les TextField de la vue passée en paramètre */
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
            }.flatMap({$0})
    }
    
    /* Retourne tous les Switch de la vue passée en paramètre */
    func getAllSwitchFields(fromView view: UIView)-> [UISwitch] {
        return view.subviews.compactMap { (view) -> [UISwitch]? in
            if view is UISwitch {
                return [(view as! UISwitch)]
            } else {
                return getAllSwitchFields(fromView: view)
            }
            }.flatMap({$0})
    }
    
    /* Retourne tous les SegmentedControl de la vue passée en paramètre */
    func getAllSegmentedFields(fromView view: UIView)-> [UISegmentedControl] {
        return view.subviews.compactMap { (view) -> [UISegmentedControl]? in
            if view is UISegmentedControl {
                return [(view as! UISegmentedControl)]
            } else {
                return getAllSegmentedFields(fromView: view)
            }
            }.flatMap({$0})
    }
    
}

