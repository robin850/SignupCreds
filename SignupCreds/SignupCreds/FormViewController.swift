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
                    y += generateTextField(value: values[0] as String, y: y, marginBottom: marginBottom)
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
        
        print("Ca marche")
        let allTextField = getAllTextFields(view: self.view)
        let allSegmentedField = getAllSegmentedFields(view: self.view)
        let allSwitchField = getAllSwitchFields(view: self.view)
        
        if(!(allTextField.isEmpty)) {
            for txtField in allTextField
            {
                userDict.updateValue((txtField.text as! String), forKey: (txtField.accessibilityIdentifier as! String))
            }
        }

        if(!(allSegmentedField.isEmpty)) {
            for segmentedField in allSegmentedField
            {
                userDict.updateValue((segmentedField.titleForSegment(at: segmentedField.selectedSegmentIndex) as! String), forKey: (segmentedField.accessibilityIdentifier as! String))
            }
        }
        
        if(!(allSwitchField.isEmpty)) {
            for switchField in allSwitchField
            {
                userDict.updateValue((switchField.isOn), forKey: (switchField.accessibilityIdentifier as! String))
            }
        }

        userArray.append(userDict)
    }

    func generateTextField(value: String, y: CGFloat, marginBottom: CGFloat) -> CGFloat {
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

    /* Retourne tous les TextField de la vue passée en paramètre */
    func getAllTextFields(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getAllTextFields(view: subview)
            }
        }
        return results
    }
    
    /* Retourne tous les Switch de la vue passée en paramètre */
    func getAllSwitchFields(view: UIView) -> [UISwitch] {
        var results = [UISwitch]()
        for subview in view.subviews as [UIView] {
            if let switchField = subview as? UISwitch {
                results += [switchField]
            } else {
                results += getAllSwitchFields(view: subview)
            }
        }
        return results
    }
    
    /* Retourne tous les SegmentedControl de la vue passée en paramètre */
    func getAllSegmentedFields(view: UIView) -> [UISegmentedControl] {
        var results = [UISegmentedControl]()
        for subview in view.subviews as [UIView] {
            if let segmentedField = subview as? UISegmentedControl {
                results += [segmentedField]
            } else {
                results += getAllSegmentedFields(view: subview)
            }
        }
        return results
    }
    
}
