//
//  FormViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class FormViewController: BaseController {
    private var textFields : [UITextField : Bool] = [:]
    private var switches : [UISwitch] = []
    private var segments : [UISegmentedControl] = []
    private var buttons : [String : [UISegmentedControl]] = [:]

    private let marginBottom : CGFloat! = CGFloat(20)

    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle(title: "Formulaire")

        /* Génération dynamique de la vue */
        generateForm(service: -1)
    }

    /// Permet de générer le formulaire.
    ///
    /// Les éléments du fichier JSON placés dans la section du service
    /// actuellement sélectionné sont lus un à un et transformés sous
    /// forme d'éléments natifs pour représenter le formulaire.
    ///
    /// Lorsque le service spécifié est `-1`, le formulaire n'est pas
    /// généré et un message indique à l'utilisateur qu'il doit en
    /// choisir un.
    ///
    /// - Parameter service : Le service associé au formulaire.
    func generateForm(service: Int) {
        /* Position des éléments dans la vue */
        var y : CGFloat = 0
        
        /* Création d'un label pour indiquer à l'utilisateur de faire un choix de service */

        if (service == -1) {
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: 100))
            label.text = "Vous n'avez pas sélectionné de service. Veuillez vous rendre dans l'onglet Services s'il vous plait."
            label.textColor = UIColor.black
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 17.0)
            label.sizeToFit()

            y += label.frame.height + marginBottom

            scrollView.contentSize = CGSize(
                width: self.view.frame.width,
                height: y - barHeight
            )

            self.view.addSubview(scrollView)
            self.scrollView.addSubview(label)

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
                    y += generateTextField(
                        value: values[0] as String,
                        y: y,
                        mandatory: (element["mandatory"] as! String == "true")
                    )
                } else if (type == "radioGroup") {
                    y += generateRadioGroup(
                        section: element["section"] as! String,
                        items: values,
                        y: y
                    )
                } else if (type == "switch") {
                    y += generateSwitch(
                        label: element["section"] as! String,
                        y: y
                    )
                } else if (type == "label") {
                    y += generateLabel(
                        label: values[0] as String,
                        y: y
                    )
                } else if (type == "button") {
                    let section = element["section"] as! String
                    let elems   = buttons[section]

                    if (elems != nil) {
                        y += generateButtons(label: section, elems: elems!, y: y)

                        // Pour éviter de générer autant de fois qu'il n'y a de boutons
                        buttons[section] = nil
                    }
                }
            }
            
            /* Génération du bouton de validation */
            let button = UIButton(frame:
                CGRect(
                    x: 0, y: y,
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

            scrollView.contentSize = CGSize(
                width: self.view.frame.width,
                height: y + button.frame.height
            )

            self.scrollView.addSubview(button)
            self.view.addSubview(scrollView)
        }
    }

    /// Gestionnaire d'évènement appelé lors du clique sur le bouton
    /// d'envoie du formulaire.
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
                userDict.updateValue((switchField.isOn ? "Oui" : "Non"), forKey: (switchField.accessibilityIdentifier ?? ""))
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

        userArray = UserDefaults.standard.array(forKey: serviceName(index: controller.service)) ?? []
        userArray.append(userDict)

        // On nettoie le formulaire une fois toutes les valeurs extraites
        clearForm()

        UserDefaults.standard.set(userArray, forKey: serviceName(index: controller.service))
        controller.selectedIndex = 2
    }

    /// Permet de générer un champ texte dans le formulaire et retourne
    /// la hauteur de l'élément généré avec sa marge.
    ///
    /// - Parameters:
    ///   - value: Nom du champ (placeholder).
    ///   - y: La position courante en hauteur.
    ///   - mandatory: Spécifie si le champ est requis ou non.
    func generateTextField(value: String, y: CGFloat, mandatory: Bool) -> CGFloat {
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

    /// Permet de générer un groupe de boutons radio et retourne la hauteur
    /// de l'élément généré avec sa marge.
    ///
    /// - Parameters:
    ///   - section: Nom du groupe de boutons.
    ///   - items: Liste de boutons à générer.
    ///   - y: La position courante en hauteur.
    func generateRadioGroup(section: String, items: [String], y: CGFloat) -> CGFloat {
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

    /// Permet de générer un switch (bouton on/off) et retourne la hauteur
    /// de l'élément généré avec sa marge.
    ///
    /// - Parameters:
    ///   - label: Nom de l'élément.
    ///   - y: La position courante en hauteur.
    func generateSwitch(label: String, y: CGFloat) -> CGFloat {
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

    /// Permet de générer un label et retourne la hauteur de l'élément
    /// généré avec sa marge.
    ///
    /// Méthode utile pour la génération des sections dans le formulaire.
    ///
    /// - Parameters:
    ///   - label: Texte du label.
    func generateLabel(label: String, y: CGFloat) -> CGFloat {
        let labelElem = UILabel(
            frame: CGRect(
                x: 16, y: y,
                width: self.view.frame.width - 32,
                height: 30
            )
        )
        
        labelElem.text = label
        labelElem.font = UIFont.systemFont(ofSize: 18)
        labelElem.sizeToFit()
        
        self.scrollView.addSubview(labelElem)
        
        return labelElem.frame.height + marginBottom
    }

    /// Permet de générer un groupe de boutons et retourne la hauteur du
    /// groupe généré (sur une seule ligne) ainsi que la marge associée.
    ///
    /// - Parameters:
    ///   - label: Nom du groupement de boutons.
    ///   - elems: Liste des boutons à générer.
    ///   - y: La position courante en hauteur.
    func generateButtons(label: String, elems: [String], y: CGFloat) -> CGFloat {
        var x = CGFloat(16)
        var margin = CGFloat(marginBottom)
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

    /// Permet de nettoyer le formulaire.
    func clearForm() {
        for (field, _) in textFields {
            field.text = ""
        }

        for segment in segments {
            segment.selectedSegmentIndex = 0
        }

        for (_, btns) in buttons {
            btns.forEach() { btn in
                btn.selectedSegmentIndex = -1
            }
        }
    }
}
