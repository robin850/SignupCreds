//
//  BaseController.swift
//  SignupCreds
//
//  Created by Robin Dupret on 12/11/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

protocol BaseController {
}

extension BaseController {
    func displayModalController() -> UIAlertController {
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
        
        /* Création du popup */
        let alertController = UIAlertController(title: "Infos Système", message: x, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
    func setModalButtonStyle(button : UIButton) {
        let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = appleBlue.cgColor
    }
    
    /* Calcul de la mémoire ROM utilisée */
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {return nil}
        return freeSize.int64Value
    }
    
    /* Calcul de la mémoire ROM totale */
    func deviceSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemSize] as? NSNumber
            else {return nil}
        return freeSize.int64Value
    }

}
