//
//  inning.swift
//  DLCalc
//
//  Created by Sachit Anil Kumar on 07/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import Foundation

class Inning {
    
    //MARK: Properties
    let G50 = 245.0
    var inningPosition: Int
    var oversAtBeginning: Double
    
    var finalScore: Int?
    var wicketsLost: Int?
    var overs: Double?
    var resourcesAtBeginning: Double?
    var resourcesLostTotal: Double?
    var resourcesLost: [Double]?
    var resourcesAvail: Double?
    var parScore: Int?
    var target: Int?
    var interruptions: [Interruption]?
    var oversReducedToLast: Double?
    var oversForTargetCalculation: Double?
    
    //MARK: Initialization
    init?(inningPosition: Int, oversAtBeginning: Double) {
        if (oversAtBeginning == 0.0 || oversAtBeginning > 50.0) {
            return nil
        }
        if (inningPosition != 1 && inningPosition != 2){
            return nil
        }
        
        // Initialize stored properties.
        self.inningPosition = inningPosition
        self.oversAtBeginning = oversAtBeginning
        self.resourcesLost = []
        self.resourcesLostTotal = 0.0
    }
    
    func setResourcesLostTotal(){
        guard let resourcesLostArray = self.resourcesLost else {
            fatalError("resourcesLost is not available")
        }
        self.resourcesLostTotal = resourcesLostArray.reduce(0, {x, y in x + y})
    }
    
    func setResourcesAvail(){
        let fileName = "dlTable"
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        do {
            let content = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            
            let parsedCSV: [[CustomStringConvertible]] = content
                .components(separatedBy: "\n")
                .map({ // Step 1
                    $0.components(separatedBy: ",")
                        .map({ // Step 2
                            if let double = Double($0) {
                                return double
                            }
                            return $0
                        })
                })
            guard let resourcesAvailAtBeginnning = parsedCSV [Int(self.oversAtBeginning * 10)][0] as? Double else {
                fatalError("some error happened")
            }
            self.resourcesAtBeginning = resourcesAvailAtBeginnning
            self.convertInterruptionsToResourcesLost()
            self.setResourcesLostTotal()
            self.resourcesAvail = resourcesAvailAtBeginnning - self.resourcesLostTotal!
        } catch {
            print("nil")
        }
    }
    
    func addPrematureTermination(oversAtStop: Double, wickets: Int){
        
        guard (self.inningPosition == 2) else {
            fatalError("prematureTermination should only happen for 2nd innings")
        }
        
        let oversRemaining = subtractOvers(first: self.oversReducedToLast!, second: oversAtStop)
        
        let fileName = "dlTable"
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        do {
            let content = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            
            let parsedCSV: [[CustomStringConvertible]] = content
                .components(separatedBy: "\n")
                .map({ // Step 1
                    $0.components(separatedBy: ",")
                        .map({ // Step 2
                            if let double = Double($0) {
                                return double
                            }
                            return $0
                        })
                })
            guard let resourcesAvailAtBeginnning = parsedCSV [Int(self.oversAtBeginning * 10)][0] as? Double else {
                fatalError("some error happened")
            }
            
            guard let resourcesAvailAtSuspension = parsedCSV [Int(oversRemaining * 10)][wickets] as? Double else {
                fatalError("some error happened")
            }
            let resourcesAvailAtResumption = 0.0 // for termination there is no resumption and thus no resources avaiable at resumption
            let resourcesLostDueToThisInteruption = resourcesAvailAtSuspension - resourcesAvailAtResumption
            
            self.resourcesLost?.append(resourcesLostDueToThisInteruption)
            self.setResourcesLostTotal()
            self.resourcesAvail = resourcesAvailAtBeginnning - self.resourcesLostTotal!
        } catch {
            print("nil")
        }
    }
    
    func subtractOvers (first: Double, second: Double) -> Double{
        
        guard (second <= first) else{
            fatalError("trying to subtract higher value from lower")
        }
        
        var overs_f = floor(first)
        var balls_f = floor((first - overs_f) * 10.0 + 0.5)
        if (balls_f > 5) {
            balls_f = balls_f - 6
            overs_f = overs_f + 1
        }
        var overs_s = floor(second)
        var balls_s = floor((second - overs_s) * 10.0 + 0.5)
        if (balls_s > 5) {
            balls_s = balls_s - 6
            overs_s = overs_s + 1
        }
        
        var subtractedOvers = overs_f - overs_s
        var subtractedBalls = balls_f - balls_s
        
        if (subtractedBalls < 0) {
            subtractedOvers = subtractedOvers - 1
            subtractedBalls = subtractedBalls + 6
        }
        
        let returnOvers = subtractedOvers + (subtractedBalls / 10.0)
        return returnOvers
    }
    
    func setParScore(firstInning: Inning){
        guard (self.inningPosition == 2) else {
            fatalError("parScore and target calculation should only happen for 2nd inning")
        }
        guard firstInning.finalScore != nil else {
            fatalError("firstInning.finalScore not available")
        }
        guard firstInning.resourcesAvail != nil else {
            fatalError("firstInning.resourcesAvail not available")
        }
        guard self.resourcesAvail != nil else {
            fatalError("secondInning.resourcesAvail not available")
        }
        
        var parScoreDouble = 0.0
        
        if (self.resourcesAvail?.isEqual(to: firstInning.resourcesAvail!))!{
            parScoreDouble = Double(firstInning.finalScore!)
        } else if (self.resourcesAvail?.isLess(than: firstInning.resourcesAvail!))! {
            parScoreDouble = Double(firstInning.finalScore!) * (self.resourcesAvail! / firstInning.resourcesAvail!)
        } else {
            parScoreDouble = Double(firstInning.finalScore!) + (self.resourcesAvail! - firstInning.resourcesAvail!) * G50 / 100
        }
        
        let parScoreInt = Int(floor(parScoreDouble))
        self.parScore = parScoreInt
    }
    
    func getFormattedParScore() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        let parScoreString = formatter.string(from: self.parScore! as NSNumber)
        return parScoreString!
    }
    
    func getFormattedTarget() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        let targetString = formatter.string(from: self.target! as NSNumber)
        return targetString!
    }
    
    func convertInterruptionsToResourcesLost(){
        
        let fileName = "dlTable"
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        do {
            let content = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            
            let parsedCSV: [[CustomStringConvertible]] = content
                .components(separatedBy: "\n")
                .map({ // Step 1
                    $0.components(separatedBy: ",")
                        .map({ // Step 2
                            if let double = Double($0) {
                                return double
                            }
                            return $0
                        })
                })
            
            if (self.interruptions != nil){
                let count = self.interruptions?.count
                if (count?.distance(to: 0) != 0){
                    for index in 0...((self.interruptions?.count)! - 1){
                        let interruption = interruptions![index]
                        let overRemAtStartSusp = subtractOvers(first: self.oversReducedToLast!, second: interruption.oversAtSuspension)
                        let overRemAtStopSusp = subtractOvers(first: interruption.oversReducedTo, second: interruption.oversAtSuspension)
                        self.oversReducedToLast = interruption.oversReducedTo
                        
                        guard let resourcesRemAtStartSusp = parsedCSV [Int(overRemAtStartSusp * 10)][interruption.wicketsAtSuspension] as? Double else {
                            fatalError("some error happened")
                        }
                        guard let resourcesRemAtStopSusp = parsedCSV [Int(overRemAtStopSusp * 10)][interruption.wicketsAtSuspension] as? Double else {
                            fatalError("some error happened")
                        }
                        
                        self.resourcesLost?.append(resourcesRemAtStartSusp - resourcesRemAtStopSusp)
                    }
                }
            }
        } catch {
            print("nil")
        }
    }
    
    func setTarget(firstInning: Inning) {
        guard (self.inningPosition == 2) else {
            fatalError("parScore and target calculation should only happen for 2nd inning")
        }
        guard firstInning.finalScore != nil else {
            fatalError("firstInning.finalScore not available")
        }
        guard firstInning.resourcesAvail != nil else {
            fatalError("firstInning.resourcesAvail not available")
        }
        guard self.resourcesAvail != nil else {
            fatalError("secondInning.resourcesAvail not available")
        }
        
        var parScoreDouble = 0.0
        
        if (self.resourcesAvail?.isEqual(to: firstInning.resourcesAvail!))!{
            parScoreDouble = Double(firstInning.finalScore!)
        } else if (self.resourcesAvail?.isLess(than: firstInning.resourcesAvail!))! {
            parScoreDouble = Double(firstInning.finalScore!) * (self.resourcesAvail! / firstInning.resourcesAvail!)
        } else {
            parScoreDouble = Double(firstInning.finalScore!) + (self.resourcesAvail! - firstInning.resourcesAvail!) * G50 / 100
        }
        
        let parScoreInt = Int(floor(parScoreDouble))
        let targetInt = parScoreInt + 1
        self.target = targetInt
    }
}
