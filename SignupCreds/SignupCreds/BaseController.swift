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
        
        var x = ""
        if kerr == KERN_SUCCESS {
            x = ("Mémoire RAM utilisée : \(info.resident_size / UInt64(exactly: 1e6)!) MB")
        }
        else {
            x = "Erreur task_info(): " +
                (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error")
        }
        
        if let bytes = deviceRemainingFreeSpaceInBytes() {
            x += "\nMémoire ROM disponible : \(bytes / Int64(exactly: 1e9)!) GB"
        } else {
            x += "\nMémoire ROM disponible : Erreur !"
        }
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
    
    func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                // something failed
                return nil
        }
        return freeSize.int64Value
    }

}
