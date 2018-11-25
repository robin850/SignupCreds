//
//  SecondViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ResultsViewController : UIViewController, BaseController {
    @IBOutlet weak var alertButton : UIButton!
    @IBOutlet weak var scrollView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setModalButtonStyle(button: self.alertButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let controller = self.tabBarController! as! BarController

        generateCards(service: controller.service ?? -1)
    }
    
    func generateCards(service : Int) {
        
        var y : CGFloat = 0
        var yLabel : CGFloat = 0
        let marginLabel : CGFloat = 10
        let marginBottom : CGFloat = 20
        
        if(service == -1) {
            /* Génération d'un label demandant de choisir un service */
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.scrollView.frame.width, height: 100))
            label.text = "Vous n'avez pas sélectionné de service. Veuillez vous rendre dans l'onglet Services s'il vous plait."
            label.textColor = UIColor.black
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 17.0)
            self.scrollView.addSubview(label)
            y += label.frame.height + marginBottom
        } else {
            /* Nettoyage de la vue avant de générer les Cards Users */
            self.scrollView!.subviews.forEach({$0.removeFromSuperview()})
            
            /* Récupération des Users via UserDefaults */
            let users = UserDefaults.standard.array(forKey: serviceName(index: service))!
            for i in 0...(users.count - 1) {
                /* Calcul du nombre de labels à mettre dans la card */
                let nbEntries : CGFloat = CGFloat((users[i] as AnyObject).count)
                /* Calcul de la taille de la card en fonction du nombre d'entrées */
                let heightCard : CGFloat = ((nbEntries * 17) + ((nbEntries - 1) * marginLabel))
                /* Génération d'une card vide afin d'y ajouter les labels */
                let card = generateCard(y: y, height: heightCard)

                /* Génération d'un label pour chaque valeur */
                for (key, value) in users[i] as! NSDictionary {
                    let label = UILabel(frame: CGRect(x: 16,
                                                      y: yLabel,
                                                      width: self.scrollView.frame.width,
                                                      height: 17))
                    label.text = value as? String ?? "caca"
                    label.textColor = UIColor.black
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 17.0)
                    
                    yLabel += label.frame.height + marginLabel
                    card.addSubview(label)
                }
                self.scrollView.addSubview(card)
                y += 135
            }
        }
    }
    
    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }
    
    /* Génération d'une card pour afficher un User */
    func generateCard(y: CGFloat, height: CGFloat) -> UIView {
        let card = UIView(frame: CGRect(x: 16,
                                        y: y,
                                        width: self.view.frame.width - 32,
                                        height: height))
        card.backgroundColor = UIColor.white
        card.layer.cornerRadius = 10.0
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 7.0
        card.layer.shadowOffset = .zero
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
        
        return card
    }
}
