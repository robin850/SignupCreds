//
//  FourthViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class AboutViewController : BaseController {
    var label = UILabel()
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)

        setTitle(title: "À propos")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
        
        label.frame = CGRect(
            x: 16, y: 0,
            width: self.view.frame.width - 32,
            height: 100
        )
        
        label.text = "Cette application a été développée dans le cadre du module Compilation et Développement d'Applications Mobiles par :\n\nSamuel Bazniar\nThomas Delhaye\nRobin Dupret"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.sizeToFit()
        
        self.scrollView.addSubview(label)
        
        generateButton()
    }
    
    func generateButton() {
        let controller = self.tabBarController! as! BarController
        button.frame = CGRect(
                        x: 16, y: label.frame.minY + label.frame.height + 20,
                        width: self.view.frame.width - 32,
                        height: 50
                       )
        
        button.setTitleColor(
            UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),
            for: .normal
        )
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
        button.titleLabel?.textAlignment = NSTextAlignment.center
        
        button.addTarget(
            self,
            action: #selector(AboutViewController.buttonAction(_:)),
            for: .touchUpInside
        )
        
        if((controller.service) != -1) {
            button.setTitle("Supprimer les valeurs du service sélectionné (" + serviceName(index: controller.service) + ")", for: .normal)
            self.scrollView.addSubview(button)
        }
    }
    
    @objc func buttonAction(_ sender: UIButton!)
    {
        let controller = self.tabBarController! as! BarController
        UserDefaults.standard.removeObject(forKey: serviceName(index: controller.service))
        
        let name = UIImage.gifImageWithName("soundsright")
        let imageView = UIImageView(image: name)
        let ratio : CGFloat = CGFloat(480) / (self.view.frame.width - 32)
        imageView.frame = CGRect(x: 16.0, y: button.frame.minY + button.frame.height + 20, width: 480 / ratio, height: 352 / ratio)
        scrollView.addSubview(imageView)
    }
}
