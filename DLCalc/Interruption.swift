//
//  Interruption.swift
//  DLCalc
//
//  Created by Sachit Anil Kumar on 08/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import UIKit

class Interruption {
    var oversAtSuspension: Double
    var wicketsAtSuspension: Int
    var oversReducedTo: Double
    var resourceLost: Double?
    
    init?(oversAtSuspension: Double, oversReducedTo: Double, wicketsAtSuspension: Int) {
        guard (oversAtSuspension.isLess(than: oversReducedTo)) else {
            return nil
        }
        self.oversAtSuspension = oversAtSuspension
        self.oversReducedTo = oversReducedTo
        self.wicketsAtSuspension = wicketsAtSuspension
    }
}
