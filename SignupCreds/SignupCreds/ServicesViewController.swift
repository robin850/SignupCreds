//
//  ThirdViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ServicesViewController : UIViewController, BaseController {
    
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    @IBOutlet weak var scrollView: UIView!

    private var cards = Array<CardHighlight>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setModalButtonStyle(button: alertButton)

        /* Marge poour qu'on voit la première ombre en entier */
        var margeOmbre = CGFloat(25)

        /* Taille de la boite */
        let largeur = CGFloat(self.view.frame.width - 32)

        /* Hauteur globale de la scrollView */
        let hauteurGlobale = CGFloat(margeOmbre + 2 * largeur + 100)

        /* Hauteur totale ; hauteur de la scrollview + la nouvelle calculée */
        let nouvelleHauteur = CGFloat(self.scrollView.frame.height + hauteurGlobale)

        self.scrollViewContainer.frame = CGRect(
            x: 0,
            y: 139,
            width: self.scrollViewContainer.frame.width,
            height: self.scrollViewContainer.frame.height + nouvelleHauteur
        )

        self.scrollView.frame = CGRect(
            x: 0,
            y: 139,
            width: self.scrollView.frame.width,
            height: self.scrollView.frame.height + nouvelleHauteur
        )

        self.view.frame = CGRect(
            x: 0,
            y: 0,
            width: self.scrollView.frame.width,
            height: self.scrollView.frame.height + nouvelleHauteur + 139
        )

        forEachService(closure: { (title, imageData, serviceIndex) in
            let image = UIImage(data: imageData as Data)

            let card = CardHighlight(frame: CGRect(x: 16, y: margeOmbre, width: largeur , height: largeur - 64))

            card.backgroundColor = UIColor(
                red:   51/255,
                green: 51/255,
                blue:  51/255,
                alpha: 1
            )

            card.icon       = image
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
            margeOmbre = margeOmbre + largeur + CGFloat(40)

            self.cards.append(card)
        })
    }

    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }

    /* Permet de parcourir tous les éléments */
    func forEachService(closure: @escaping (_ title : String, _ image: NSData, _ index : Int) -> Void) {
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")

        do {
            let data = try Data(contentsOf: jsonPath!)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonServices = json as! [String : Any]

            var indice = 0

            for title in jsonServices["services"] as! Array<[String: Any]> {
                for element in title["elements"] as! Array<[String : Any]> {
                    let section = element["section"] as! String

                    if (section == "title") {
                        let values = element["value"] as! Array<String>
                        for valeur in values {

                            let imageUrlString = valeur
                            let imageUrl:URL = URL(string: imageUrlString)!

                            DispatchQueue.global(qos: .userInitiated).async {
                                let imageData:NSData = NSData(contentsOf: imageUrl)!
                                DispatchQueue.main.async {
                                    closure(title["title"] as! String, imageData, indice)
                                    indice = indice + 1
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
