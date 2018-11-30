//
//  FourthViewController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 27/09/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class AboutViewController : BaseController {
    
    @IBOutlet weak var alertButton: UIButton!
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 2000
        
        return view
    }()
    
    var label = UILabel()
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 139.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setModalButtonStyle(button: alertButton)
        
        label.frame = CGRect(
                        x: 16, y: 0,
                        width: self.view.frame.width - 32,
                        height: 100
                      )
        
        label.text = "Cette application a été développée dans le cadre du module Compilation et Développement d'Applications Mobiles par :\n\nSamuel Bazniar\nThomas Delhaye\nRobin Dupret\n"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.sizeToFit()
        
        self.scrollView.addSubview(label)
        
        generateButton()
        
    }
    
    func generateButton() {
        let controller = self.tabBarController! as! BarController
        button.frame = CGRect(
                        x: 16, y: label.frame.height + 20,
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
    }

    @IBAction func modalButtonClick(sender _ : Any) {
        let controller = displayModalController()
        present(controller, animated: true, completion: nil)
    }
}
