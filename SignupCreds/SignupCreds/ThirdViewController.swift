//
//  ThirdViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit
import Cards

class ThirdViewController : UIViewController {
    
    @IBOutlet weak var alertButton: UIButton!
    let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    
    @IBOutlet weak var titre: UILabel!
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    @IBOutlet weak var scrollView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var margeOmbre = CGFloat(25) // Marge poour qu'on voit la première ombre en entier
        let largeur = CGFloat(self.view.frame.width - 32) // Taille de la boite
        let hauteurGlobale = CGFloat(margeOmbre + 2 * largeur + 100) // Hauteur globale de la scrollView avec deux boites
        let nouvelleHauteur = CGFloat(self.scrollView.frame.height + hauteurGlobale)
        self.scrollViewContainer.frame = CGRect(x: 0, y: 139, width: self.scrollViewContainer.frame.width, height: self.scrollViewContainer.frame.height + nouvelleHauteur)
        self.scrollView.frame = CGRect(x: 0, y: 139, width: self.scrollView.frame.width, height: self.scrollView.frame.height + nouvelleHauteur)
        self.view.frame = CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height + nouvelleHauteur + 139)
        
        self.alertButton.backgroundColor = .clear
        self.alertButton.layer.cornerRadius = 15
        self.alertButton.layer.borderWidth = 1
        self.alertButton.layer.borderColor = appleBlue.cgColor
        
        let jsonPath = Bundle.main.url(forResource: "service", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: jsonPath!)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonServices = json as! [String : Any]
            
            for title in jsonServices["services"] as! Array<[String: Any]> {
                for element in title["elements"] as! Array<[String : Any]> {
                    let section = element["section"] as! String
                    
                    if(section == "title") {
                        let values = element["value"] as! Array<String>
                        for valeur in values {
                            
                            let imageUrlString = valeur
                            let imageUrl:URL = URL(string: imageUrlString)!
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                let imageData:NSData = NSData(contentsOf: imageUrl)!
                                DispatchQueue.main.async {
                                    let image = UIImage(data: imageData as Data)
                                
                                    let card = CardHighlight(frame: CGRect(x: 16, y: margeOmbre, width: largeur , height: largeur))
                                    
                                    card.backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
                                    card.icon = image
                                    card.title = title["title"] as! String
                                    card.itemTitle = "Inscription"
                                    card.itemSubtitle = ""
                                    card.textColor = UIColor.white
                                    card.buttonText = "Sélectionner"
                                    
                                    card.hasParallax = true
                                    
                                    let cardContentVC = self.storyboard!.instantiateViewController(withIdentifier: "Services")
                                    card.shouldPresent(cardContentVC, from: self, fullscreen: false)
                                    
                                    self.scrollView.addSubview(card)
                                    margeOmbre = margeOmbre + largeur + CGFloat(40)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}
