//
//  SecondViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ResultsViewController : BaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setTitle(title: "Nos membres")

        let controller = self.tabBarController! as! BarController

        generateCards(service: controller.service ?? -1)
    }
    
    func generateCards(service : Int) {
        
        var y : CGFloat = 0
        let marginLabel : CGFloat = 10
        let separatorHeight : CGFloat = 2
        
        if(service == -1) {
            /* Génération d'un label demandant de choisir un service */
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: 100))
            label.text = "Vous n'avez pas sélectionné de service. Veuillez vous rendre dans l'onglet Services s'il vous plait."
            label.textColor = UIColor.black
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 17.0)
            label.sizeToFit()
            self.scrollView.addSubview(label)

            scrollView.contentSize = CGSize(
                width: self.view.frame.width,
                height: label.frame.height
            )

            self.view.addSubview(scrollView)
        } else {
            /* Nettoyage de la vue avant de générer les Cards Users */
            self.scrollView.subviews.forEach({$0.removeFromSuperview()})
            
            /* Récupération des Users via UserDefaults */
            if(UserDefaults.standard.array(forKey: serviceName(index: service)) != nil) {
                let users = UserDefaults.standard.array(forKey: serviceName(index: service))!
                for i in 0...(users.count - 1) {
                    /* Génération d'un label pour chaque valeur */
                    for (key, value) in users[i] as! NSDictionary {
                        let label = UILabel(frame: CGRect(x: 16,
                                                          y: y,
                                                          width: self.view.frame.width - 32,
                                                          height: 100))
                        label.text = ((key as? String ?? "") + " : " + (value as? String ?? ""))
                        label.textColor = UIColor.black
                        label.numberOfLines = 0
                        label.font = UIFont.systemFont(ofSize: 17.0)
                        label.sizeToFit()
                        self.scrollView.addSubview(label)
                        y += label.frame.height + marginLabel
                    }
                    generateSeparator(y: y, separatorHeight: separatorHeight)
                    y += separatorHeight + marginLabel
                }

                scrollView.contentSize = CGSize(
                    width: self.view.frame.width,
                    height: y
                )

                self.view.addSubview(scrollView)
            } else {
                let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: 100))
                label.text = "Il n'existe aucun membre pour ce service. Ajoutez en un dès maintenant dans l'onglet Formulaire"
                label.textColor = UIColor.black
                label.numberOfLines = 0
                label.font = UIFont.systemFont(ofSize: 17.0)
                label.sizeToFit()

                self.scrollView.addSubview(label)
                self.view.addSubview(scrollView)
            }
        }
    }
    
    func generateSeparator(y: CGFloat, separatorHeight: CGFloat) {
        let separator = UIView(frame: CGRect(x: 16, y: y, width: self.view.frame.width - 32, height: separatorHeight))
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.scrollView.addSubview(separator)
    }
}
