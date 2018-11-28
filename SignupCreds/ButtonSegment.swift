//
//  ButtonSegment.swift
//  SignupCreds
//
//  Created by Robin Dupret on 28/11/2018.
//  Copyright © 2018 Sathoro. All rights reserved.
//

import UIKit

class ButtonSegment: UISegmentedControl {
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        if (self.selectedSegmentIndex == 0) {
            self.selectedSegmentIndex = -1
        } else {
            self.selectedSegmentIndex = 0
        }
    }
}
