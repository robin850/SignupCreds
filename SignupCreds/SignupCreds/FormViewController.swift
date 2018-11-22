//
//  FormViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, BaseController {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var scrollView: UIView!

    private var textFields : [UITextField : Bool] = [:]
    private var switches : [UISwitch] = []
    private var segments : [UISegmentedControl] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setModalButtonStyle(button: alertButton)
        
        /* Génération dynamique de la vue */
        generateForm(service: -1)
    }
    
    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }
    
    func generateForm(service: Int) {
        /* Position des éléments dans la vue */
        var y : CGFloat = 0
        
        /* Marge à placer pour passer à la catégorie suivante */
        let marginBottom : CGFloat = 20
        
        /* Création d'un label pour indiquer à l'utilisateur de faire un choix de service */
        
        if(service == -1) {
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.scrollView.frame.width, height: 100))
            label.text = "Vous n'avez pas sélectionné de service. Veuillez vous rendre dans l'onglet Services s'il vous plait."
            label.textColor = UIColor.black
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 17.0)
            self.scrollView.addSubview(label)
            y += label.frame.height + marginBottom
        } else {
            self.scrollView!.subviews.forEach({$0.removeFromSuperview()})

            /* Récupération du fichier JSON */
            let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
            let data = try! Data(contentsOf: jsonPath!)
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            let jsonServices = json as! [String : Any]
            let services     = jsonServices["services"] as! Array<[String: Any]>
            
            let currentService = services[service]
            let elements       = currentService["elements"] as! Array<[String: Any]>
            
            for element in elements {
                let values = element["value"] as! Array<String>
                let type   = element["type"] as! String
                
                if (type == "edit") {
                    y += generateTextField(value: values[0] as String, y: y, marginBottom: marginBottom, mandatory: (element["mandatory"] as! String == "true"))
                } else if (type == "radioGroup") {
                    y += generateRadioGroup(items: values, y: y, marginBottom: marginBottom)
                } else if (type == "switch") {
                    y += generateSwitch(label: values[0] as String, y: y, marginBottom: marginBottom)
                } else if (type == "label") {
                    y += generateLabel(label: values[0] as String, y: y, marginBottom: marginBottom)
                }
            }
            
            /* Génération du bouton de validation */
            let button = UIButton(frame:
                CGRect(
                    x: 16, y: y,
                    width: self.scrollView.frame.width,
                    height: 50
                )
            )
            
            button.setTitle("Enregistrer", for: .normal)
            button.setTitleColor(
                UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),
                for: .normal
            )
            
            button.addTarget(
                self,
                action: #selector(FormViewController.buttonAction(_:)),
                for: .touchUpInside
            )
            
            self.scrollView.addSubview(button)
        }
    }
    
    @objc func buttonAction(_ sender:UIButton!)
    {
        var userDict = [String:Any]()
        var userArray = [Any]()
        userDict = [:]
        
        var errors = Array<String>()

        if (!(textFields.isEmpty)) {
            for (txtField, mandatory) in textFields {
                if (mandatory && txtField.text!.isEmpty) {
                    errors.append(txtField.placeholder!)
                }
            }
        }

        if (!errors.isEmpty) {
            let message = "Vous devez remplir les champs suivants : \(errors.joined(separator: ", "))"

            self.present(
                alert(title: "Erreur lors de l'envoi", message: message),
                animated: true
            )
            return
        }

        if (!(textFields.isEmpty)) {
            for (txtField, _) in textFields {
                userDict.updateValue((txtField.text as! String), forKey: (txtField.accessibilityIdentifier as! String))
            }
        }

        if (!(segments.isEmpty)) {
            for segmentedField in segments {
                userDict.updateValue((segmentedField.titleForSegment(at: segmentedField.selectedSegmentIndex) as! String), forKey: (segmentedField.accessibilityIdentifier as! String))
            }
        }
        
        if (!(switches.isEmpty)) {
            for switchField in switches {
                userDict.updateValue((switchField.isOn), forKey: (switchField.accessibilityIdentifier as! String))
            }
        }
        
        userArray.append(userDict)
        let controller = self.tabBarController! as! BarController
        controller.selectedIndex = 2
    }

    func generateTextField(value: String, y: CGFloat, marginBottom: CGFloat, mandatory: Bool) -> CGFloat {
        let textfield = UITextField(
            frame: CGRect(
                x: 16, y: y,
                width: self.scrollView.frame.width - 32,
                height: 35
            )
        )
        
        textfield.placeholder     = value
        textfield.font            = UIFont.systemFont(ofSize: 17)
        textfield.borderStyle     = UITextField.BorderStyle.roundedRect
        textfield.keyboardType    = UIKeyboardType.default
        textfield.returnKeyType   = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.accessibilityIdentifier  = value
        
        textfield.delegate = self as? UITextFieldDelegate
        
        textFields[textfield] = mandatory

        self.scrollView.addSubview(textfield)
        
        return textfield.frame.height + marginBottom
    }
    
    func generateRadioGroup(items: [String], y: CGFloat, marginBottom: CGFloat) -> CGFloat {
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.frame = CGRect(
            x: 16, y: y,
            width: self.scrollView.frame.width,
            height: 30
        )
        
        segmentedControl.selectedSegmentIndex    = 0
        segmentedControl.accessibilityIdentifier = "type"

        segments.append(segmentedControl)

        self.scrollView.addSubview(segmentedControl)
        
        return segmentedControl.frame.height + marginBottom
    }
    
    func generateSwitch(label: String, y: CGFloat, marginBottom: CGFloat) -> CGFloat {
        let switchOnOff = UISwitch(
            frame: CGRect(
                x: 16, y: y,
                width: self.scrollView.frame.width - 32,
                height: 30
            )
        )
        
        switchOnOff.setOn(true, animated: true)
        switchOnOff.accessibilityIdentifier = label

        switches.append(switchOnOff)

        self.scrollView.addSubview(switchOnOff)
        
        return switchOnOff.frame.height + marginBottom
    }
    
    func generateLabel(label: String, y: CGFloat, marginBottom: CGFloat) -> CGFloat {
        let labelElem = UILabel(
            frame: CGRect(
                x: 16, y: y,
                width: self.scrollView.frame.width - 32,
                height: 30
            )
        )
        
        labelElem.text = label
        labelElem.font = UIFont.systemFont(ofSize: 18)
        
        self.scrollView.addSubview(labelElem)
        
        return labelElem.frame.height + marginBottom
    }
}
