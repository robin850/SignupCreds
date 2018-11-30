//
//  ThirdViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ServicesViewController : BaseController {
    
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var titre: UILabel!

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 50

        return view
    }()

    private var cards = Array<CardHighlight>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 139.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setModalButtonStyle(button: alertButton)

        /* Marge pour qu'on voit la première ombre en entier */
        var margeOmbre = CGFloat(25)

        /* Taille de la boite */
        let largeur = CGFloat(self.view.frame.width - 32)

        forEachService(closure: { (title, serviceIndex) in
            let card = CardHighlight(frame: CGRect(x: 16, y: margeOmbre, width: largeur , height: largeur - 64))

            card.backgroundColor = UIColor(
                red:   51/255,
                green: 51/255,
                blue:  51/255,
                alpha: 1
            )

            card.title      = title
            card.textColor  = UIColor.white
            card.buttonText = "Sélectionner"

            card.onClick = {
                let controller = self.tabBarController! as! BarController
                controller.service = serviceIndex

                self.cards.forEach({ $0.selected = false })
                card.selected = true
            }

            self.scrollView.addSubview(card)
            margeOmbre += largeur

            self.cards.append(card)

            return card
        })
        
        scrollView.contentSize.height = CGFloat(cards.count) * (largeur - 64) + CGFloat(cards.count - 1) * margeOmbre
        scrollView.layoutIfNeeded()
    }

    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }

    /* Permet de parcourir tous les éléments */
    func forEachService(closure: @escaping (_ title : String, _ index : Int) -> CardHighlight) {
        var indice = 0

        for service in services {
            for element in service["elements"] as! Array<[String : Any]> {
                let section = element["section"] as! String

                if (section == "title") {
                    let values = element["value"] as! Array<String>

                    for valeur in values {
                        let imageUrlString = valeur
                        let imageUrl:URL = URL(string: imageUrlString)!

                        let card = closure(service["title"] as! String, indice)

                        URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                            DispatchQueue.main.async {
                                let image = UIImage(data: data!)
                                card.icon = image
                            }
                        }).resume()

                        indice = indice + 1
                    }
                }
            }
        }
    }
}
