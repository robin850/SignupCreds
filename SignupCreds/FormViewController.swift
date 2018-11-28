//
//  FormViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FormViewController: BaseController {
    @IBOutlet weak var alertButton: UIButton!

    private var textFields : [UITextField : Bool] = [:]
    private var switches : [UISwitch] = []
    private var segments : [UISegmentedControl] = []
    private var buttons : [String : [UISegmentedControl]] = [:]

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 2000

        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 139.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: 100))
            label.text = "Vous n'avez pas sélectionné de service. Veuillez vous rendre dans l'onglet Services s'il vous plait."
            label.textColor = UIColor.black
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 17.0)
            self.scrollView.addSubview(label)
            y += label.frame.height + marginBottom
        } else {
            self.scrollView.subviews.forEach({$0.removeFromSuperview()})

            /* Clear les éléments précédents */
            textFields = [:]
            switches = []
            segments = []

            /* Récupération du fichier JSON */
            let currentService = self.services[service]
            let elements       = currentService["elements"] as! Array<[String: Any]>

            /*
             * Regroupement des boutons ensemble avant de générer le groupe
             * de boutons.
             */
            var buttons     = [String: [String]]()
            let buttonElems = elements.filter() {
                return ($0["type"] as! String) == "button"
            }

            for button in buttonElems {
                let name  = button["section"] as! String
                let value = (button["value"] as! [String])[0] as String

                if (buttons[name] == nil) {
                    buttons[name] = [String]()
                }

                buttons[name]!.append(value)
            }

            /*
             * Génération des éléments du formulaire
             */
            for element in elements {
                let values = element["value"] as! Array<String>
                let type   = element["type"] as! String
                
                if (type == "edit") {
                    y += generateTextField(value: values[0] as String, y: y, marginBottom: marginBottom, mandatory: (element["mandatory"] as! String == "true"))
                } else if (type == "radioGroup") {
                    y += generateRadioGroup(section: element["section"] as! String, items: values, y: y, marginBottom: marginBottom)
                } else if (type == "switch") {
                    y += generateSwitch(label: values[0] as String, y: y, marginBottom: marginBottom)
                } else if (type == "label") {
                    y += generateLabel(label: values[0] as String, y: y, marginBottom: marginBottom)
                } else if (type == "button") {
                    let section = element["section"] as! String
                    let elems   = buttons[section]

                    if (elems != nil) {
                        y += generateButtons(label: section, elems: elems!, y: y, marginBottom: marginBottom)

                        // Pour éviter de générer autant de fois qu'il n'y a de boutons
                        buttons[section] = nil
                    }
                }
            }
            
            /* Génération du bouton de validation */
            let button = UIButton(frame:
                CGRect(
                    x: 16, y: y,
                    width: self.view.frame.width,
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
                userDict.updateValue((txtField.text) ?? "", forKey: (txtField.accessibilityIdentifier ?? ""))
            }
        }

        if (!(segments.isEmpty)) {
            for segmentedField in segments {
                userDict.updateValue((segmentedField.titleForSegment(at: segmentedField.selectedSegmentIndex) ?? ""), forKey: (segmentedField.accessibilityIdentifier ?? ""))
            }
        }
        
        if (!(switches.isEmpty)) {
            for switchField in switches {
                userDict.updateValue((switchField.isOn), forKey: (switchField.accessibilityIdentifier ?? ""))
            }
        }

        if (!(buttons.isEmpty)) {
            for (section, controls) in buttons {
                let values = controls.filter() {
                    return $0.selectedSegmentIndex != -1
                }.map() { control in
                    control.titleForSegment(at: control.selectedSegmentIndex)!
                }.joined(separator: ", ")

                userDict.updateValue(values, forKey: section)
            }
        }
        
        let controller = self.tabBarController! as! BarController

        userArray = UserDefaults.standard.array(forKey: serviceName(index: controller.service!)) ?? []
        userArray.append(userDict)

        UserDefaults.standard.set(userArray, forKey: serviceName(index: controller.service!))
        controller.selectedIndex = 2
    }

    func generateTextField(value: String, y: CGFloat, marginBottom: CGFloat, mandatory: Bool) -> CGFloat {
        let textfield = UITextField(
            frame: CGRect(
                x: 16, y: y,
                width: self.view.frame.width - 32,
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
    
    func generateRadioGroup(section: String, items: [String], y: CGFloat, marginBottom: CGFloat) -> CGFloat {
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.frame = CGRect(
            x: 16, y: y,
            width: self.view.frame.width - 32,
            height: 30
        )
        
        segmentedControl.selectedSegmentIndex    = 0
        segmentedControl.accessibilityIdentifier = section

        segments.append(segmentedControl)

        self.scrollView.addSubview(segmentedControl)
        
        return segmentedControl.frame.height + marginBottom
    }
    
    func generateSwitch(label: String, y: CGFloat, marginBottom: CGFloat) -> CGFloat {
        let switchOnOff = UISwitch(
            frame: CGRect(
                x: 16, y: y,
                width: self.view.frame.width - 32,
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
                width: self.view.frame.width - 32,
                height: 30
            )
        )
        
        labelElem.text = label
        labelElem.font = UIFont.systemFont(ofSize: 18)
        
        self.scrollView.addSubview(labelElem)
        
        return labelElem.frame.height + marginBottom
    }

    func generateButtons(label: String, elems: [String], y: CGFloat, marginBottom: CGFloat) -> CGFloat {
        var x = CGFloat(16)
        var margin = marginBottom
        let width  = (self.view.frame.width - CGFloat(16)
                                            - CGFloat(elems.count * 16))
                        / CGFloat(elems.count)

        var controls = [UISegmentedControl]()

        for (index, element) in elems.enumerated() {
            let segmentedControl = ButtonSegment(items: [element])

            segmentedControl.frame = CGRect(
                x: x, y: y,
                width: width,
                height: 30
            )

            controls.append(segmentedControl)
            self.scrollView.addSubview(segmentedControl)

            // On incrémente la marge en hauteur une seule fois puisque
            // les éléments sont tous affichés sur la même ligne.
            if (index == 0) {
                margin += segmentedControl.frame.height
            }

            x += width + 16
        }

        self.buttons[label] = controls

        return margin
    }
}
