//
//  BaseController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 12/11/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class BaseController : UIViewController {
    var controllerTitle : UILabel = UILabel()
    var scrollView : UIScrollView = UIScrollView()
    var modalButton : UIButton = UIButton()

    let barHeight : CGFloat! = CGFloat(129)

    var services : Array<[String: Any]> {
        get {
            return (self.tabBarController! as! BarController).services
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createButton()

        scrollView.frame = CGRect(
            x: 0, y: barHeight,
            width: self.view.frame.width,
            height: self.view.frame.height
                - (self.tabBarController?.tabBar.frame.height)!
                - barHeight
        )
    }

    /// Permet d'afficher une boîte de dialogue modale avec les
    /// différentes informations systèmes:
    ///
    ///   - Utilisation de la RAM
    ///   - Utilisation de la mémoire ROM
    ///   - Utilisation du CPU
    @objc func displayModal(_ sender: UIButton!) {
        var info = mach_task_basic_info()

        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                          task_flavor_t(MACH_TASK_BASIC_INFO),
                          $0,
                          &count)
            }
        }

        /* Création de la chaine de caractères pour le popup */
        var x = ""

        /* Calcul de la RAM utilisée */
        if kerr == KERN_SUCCESS {
            x = ("Mémoire RAM utilisée : \(info.resident_size / UInt64(exactly: 1e6)!) MB")
        }
        else {
            x = "Erreur task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error")
        }

        /* Calcul de la mémoire ROM restante */
        if let usedRom = deviceRemainingFreeSpaceInBytes() {
            x += "\n\nMémoire ROM disponible : \(usedRom / Int64(exactly: 1e9)!) GB"
        } else {
            x += "\n\nMémoire ROM disponible : Erreur !"
        }

        /* Calcul de la mémoire RAM totale */
        if let totalMemory = deviceSpaceInBytes() {
            x += "\nMémoire ROM totale : \(totalMemory / Int64(exactly: 1e9)!) GB"
        } else {
            x += "\nMémoire ROM totale : Erreur !"
        }
    
        /* Infos CPU */
        var totalUsageOfCPU: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        if(totalUsageOfCPU != 0.0) {
            x += "\n\nCPU : \(totalUsageOfCPU)%"
        } else {
            x += "\n\nCPU : Erreur !"
        }


        /* Création du popup */
        let alertController = UIAlertController(title: "Infos Système", message: x, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true)
    }

    /// Permet de calculer de la mémoire ROM utilisée
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {return nil}
        return freeSize.int64Value
    }

    /// Permet de calculer la mémoire ROM totale.
    func deviceSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemSize] as? NSNumber
            else {return nil}
        return freeSize.int64Value
    }

    func alert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)

        return alertController
    }

    /// Permet de récupérer le nom du service sous forme de chaîne de
    /// caractères à partir de l'index (basé sur le fichier JSON).
    ///
    /// - Parameter index: Index du service.
    func serviceName(index: Int) -> String {
        return services[index]["title"] as! String
    }

    /// Permet de définir le texte du label représentant le titre
    /// de la vue et de correctement mettre en place le style
    /// associé.
    ///
    /// - Parameter title: Titre de la vue.
    func setTitle(title: String) {
        controllerTitle.text = title

        controllerTitle.font = UIFont.boldSystemFont(ofSize: 30)
        controllerTitle.frame = CGRect(
            x: 16, y: 70,
            width: self.view.frame.width,
            height: 40
        )

        self.view.addSubview(controllerTitle)
    }

    /// Permet de créer le bouton permettant d'afficher la popup
    /// indiquant les différentes métriques utilisée (RAM, ROM, CPU).
    func createButton() {
        let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)

        modalButton.setTitle("?", for: .normal)
        modalButton.setTitleColor(appleBlue, for: .normal)

        modalButton.backgroundColor = .clear
        modalButton.layer.cornerRadius = 15
        modalButton.layer.borderWidth = 1
        modalButton.layer.borderColor = appleBlue.cgColor

        modalButton.frame = CGRect(
            x: self.view.frame.width - 50, y: 70,
            width: 30,
            height: 30
        )

        modalButton.addTarget(
            self,
            action: #selector(self.displayModal(_:)),
            for: .touchUpInside
        )

        self.view.addSubview(modalButton)
    }
}
