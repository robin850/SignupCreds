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
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!

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
        
        setModalButtonStyle(button: self.alertButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            self.scrollView.addSubview(label)
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
                                                          height: 17))
                        label.text = ((key as? String ?? "") + " : " + (value as? String ?? ""))
                        label.textColor = UIColor.black
                        label.numberOfLines = 0
                        label.font = UIFont.systemFont(ofSize: 17.0)
                        
                        y += label.frame.height + marginLabel
                        self.scrollView.addSubview(label)
                    }
                    generateSeparator(y: y, separatorHeight: separatorHeight)
                    y += separatorHeight + marginLabel
                }
                /* Calcul du nombre de labels par User */
                let nbEntries : CGFloat = CGFloat((users[0] as AnyObject).count)
                /* Calcul de la taille d'un User en fonction du nombre d'entrées */
                let heightUser : CGFloat = ((nbEntries * (17 + marginLabel)) + separatorHeight)
                /* Calcul de la taille de la vue scrollable en fonction du nombre d'Users */
                let nbUsers = users.count
                let heightView : CGFloat = CGFloat(nbUsers) * heightUser
                print(heightView)
//                var extraHeight : CGFloat
//                if(heightScrollView.constant < heightView) {
//                    extraHeight = heightView - heightScrollView.constant
//                    heightScrollView.constant += extraHeight
//                    self.scrollView.layoutIfNeeded()
//                } else {
//                    extraHeight = heightScrollView.constant - heightView
//                    heightScrollView.constant += extraHeight
//                }
            } else {
                let label = UILabel(frame: CGRect(x: 16, y: 0, width: self.view.frame.width - 32, height: 100))
                label.text = "Il n'existe aucun membre pour ce service. Ajoutez en un dès maintenant dans l'onglet Formulaire"
                label.textColor = UIColor.black
                label.numberOfLines = 0
                label.font = UIFont.systemFont(ofSize: 17.0)
                self.scrollView.addSubview(label)
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
    
    func generateSeparator(y: CGFloat, separatorHeight: CGFloat) {
        let separator = UIView(frame: CGRect(x: 0, y: y, width: self.view.frame.width - 32, height: separatorHeight))
        separator.backgroundColor = UIColor.black
        self.scrollView.addSubview(separator)
    }
}
