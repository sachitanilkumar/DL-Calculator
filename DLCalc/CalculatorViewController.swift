//
//  CalculatorViewController.swift
//  DLCalc
//
//  Created by Sachit Anil Kumar on 07/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let wicketTeam1 = 1
    let wicketTeam2 = 2
    let overTeam1Start = 3
    let overTeam2Start = 4
    let overTeam2Current = 5
    
    let wicketsTeam1 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let wicketsTeam2 = ["","0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let oversTeam1Start = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["0", "1", "2", "3", "4", "5"]]
    let oversTeam2Start = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["0", "1", "2", "3", "4", "5"]]
    let oversTeam2Current = [["","0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["","0", "1", "2", "3", "4", "5"]]
    
    var resourcesLostTeam1:[Double] = []
    var resourcesLostTeam2:[Double] = []
    var interruptionsTeam1:[Interruption] = []
    var interruptionsTeam2:[Interruption] = []
    var overRedToInn2 = 50.0
    
    //MARK: Properties
    @IBOutlet weak var team1OversStart: UITextField!
//    @IBOutlet weak var team1Wickets: UITextField!
    @IBOutlet weak var team1FinalScore: UITextField!
    @IBOutlet weak var team2OversStart: UITextField!
    @IBOutlet weak var team2Wickets: UITextField!
    @IBOutlet weak var team2OversCurrent: UITextField!
    @IBOutlet weak var parScoreTextField: UILabel!
    @IBOutlet weak var targetTextField: UILabel!
    @IBOutlet weak var firstInningInterruptions: UIButton!
    @IBOutlet weak var secondInningInterruptions: UIButton!
    @IBOutlet weak var oversAllotedLabel: UILabel!
    @IBOutlet weak var firstInningLabel: UILabel!
    @IBOutlet weak var secondInningLabel: UILabel!
    @IBOutlet var firstInningStack: [UIStackView]!
    @IBOutlet var secondInningStack: [UIStackView]!
    @IBOutlet weak var targetOversLabel: UILabel!
    @IBOutlet weak var parScoreOverLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        team1OversStart.delegate = self
//        team1Wickets.delegate = self
        team1FinalScore.delegate = self
        team2OversStart.delegate = self
        team2Wickets.delegate = self
        
        setUpPickers()
//        firstInningLabel.frame.size.width = ((firstInningLabel.superview?.frame.size.width)! - 64) / 2
//        secondInningLabel.frame.size.width = ((firstInningLabel.superview?.frame.size.width)! - 64) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var components = 0
        if (pickerView.tag == wicketTeam1 || pickerView.tag == wicketTeam2){
            components = 1
        } else if (pickerView.tag == overTeam1Start || pickerView.tag == overTeam2Start || pickerView.tag == overTeam2Current){
            components =  2
        }
        return components
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == wicketTeam1 {
            return wicketsTeam1.count
        }
        if pickerView.tag == wicketTeam2 {
            return wicketsTeam2.count
        }
        if pickerView.tag == overTeam1Start {
            return oversTeam1Start[component].count
        }
        if pickerView.tag == overTeam2Start {
            return oversTeam2Start[component].count
        }
        if pickerView.tag == overTeam2Current {
            return oversTeam2Current[component].count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == wicketTeam1 {
            return wicketsTeam1[row]
        }
        if pickerView.tag == wicketTeam2 {
            return wicketsTeam2[row]
        }
        if pickerView.tag == overTeam1Start {
            return oversTeam1Start[component][row]
        }
        if pickerView.tag == overTeam2Start {
            return oversTeam2Start[component][row]
        }
        if pickerView.tag == overTeam2Current {
            return oversTeam2Current[component][row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView.tag == wicketTeam1 {
//            team1Wickets.text = wicketsTeam1[row]
//        }
        if pickerView.tag == wicketTeam2 {
            if wicketsTeam2[row] == "" {
                pickerView.selectRow(row + 1, inComponent: 0, animated: true)
                team2Wickets.text = wicketsTeam2[row + 1]
            } else {
                team2Wickets.text = wicketsTeam2[row]
            }
        }
        if pickerView.tag == overTeam1Start {
            let overs = oversTeam1Start[0][pickerView.selectedRow(inComponent: 0)]
            var balls = oversTeam1Start[1][pickerView.selectedRow(inComponent: 1)]
            if (overs == oversTeam1Start[0][oversTeam1Start[0].count-1] && 0 != Int(balls)){
                pickerView.selectRow(0, inComponent: 1, animated: true)
                balls = "0"
            }
            team1OversStart.text = overs + "." + balls
        }
        if pickerView.tag == overTeam2Start {
            let overs = oversTeam2Start[0][pickerView.selectedRow(inComponent: 0)]
            var balls = oversTeam2Start[1][pickerView.selectedRow(inComponent: 1)]
            if (overs == oversTeam2Start[0][oversTeam2Start[0].count-1] && 0 != Int(balls)){
                pickerView.selectRow(0, inComponent: 1, animated: true)
                balls = "0"
            }
            team2OversStart.text = overs + "." + balls
        }
        if pickerView.tag == overTeam2Current {
            var overs = oversTeam2Current[0][pickerView.selectedRow(inComponent: 0)]
            var balls = oversTeam2Current[1][pickerView.selectedRow(inComponent: 1)]
            if (overs == oversTeam2Current[0][oversTeam2Current[0].count-1] && 0 != Int(balls)){
                pickerView.selectRow(1, inComponent: 1, animated: true)
                balls = "0"
            }
            if (overs == ""){
                pickerView.selectRow(1, inComponent: 0, animated: true)
                overs = "0"
            }
            if (balls == ""){
                pickerView.selectRow(1, inComponent: 1, animated: true)
                balls = "0"
            }
            team2OversCurrent.text = overs + "." + balls
        }
        
    }

    //MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "showInterruptionsListInn1" {
                
                let team1overs = team1OversStart.text ?? ""
                if team1overs.isEmpty{
                    let alertController = UIAlertController(title: "Oops!!", message: "Overs alloted for Innings 1 at the start should be filled before adding interruptions for same.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
                
                guard let team1OversDouble = Double (team1overs) else {
                    fatalError("team1overs not a double")
                }
                if (team1OversDouble > 50.0 || team1OversDouble == 0.0){
                    let alertController = UIAlertController(title: "Oops!!", message: "Please enter valid value for overs alloted for Innings 1 at the start. Valid values are between 0.1 and 50.0", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
            } else if ident == "showInterruptionsListInn2" {
                
                let team2overs = team2OversStart.text ?? ""
                if team2overs.isEmpty{
                    let alertController = UIAlertController(title: "Oops!!", message: "Overs alloted for Innings 2 at the start should be filled before adding interruptions for same.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
                
                guard let team2OversDouble = Double (team2overs) else {
                    fatalError("team1overs not a double")
                }
                if (team2OversDouble > 50.0 || team2OversDouble == 0.0){
                    let alertController = UIAlertController(title: "Oops!!", message: "Please enter valid value for overs alloted for Innings 2 at the start. Valid values are between 0.1 and 50.0", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let interruptionsTableViewController = segue.destination as? InterruptionsTableViewController else {
            fatalError("Unexpected Destination; \(segue.destination)")
        }
        
        if (firstInningInterruptions == sender as? UIButton){
            interruptionsTableViewController.titleName = "First Innings"
            interruptionsTableViewController.interruptions = interruptionsTeam1
            
            let team1overs = team1OversStart.text ?? ""
            guard let team1OversDouble = Double (team1overs) else {
                fatalError("team1overs not a double")
            }
            interruptionsTableViewController.oversInInnings = team1OversDouble
        } else if (secondInningInterruptions == sender as? UIButton){
            interruptionsTableViewController.titleName = "Second Innings"
            interruptionsTableViewController.interruptions = interruptionsTeam2
            
            let team2overs = team2OversStart.text ?? ""
            guard let team2OversDouble = Double (team2overs) else {
                fatalError("team2overs not a double")
            }
            interruptionsTableViewController.oversInInnings = team2OversDouble
        }
    }
    
    //MARK: Actions
    @IBAction func clickParScoreButton(_ sender: UIButton) {
        
        let disallowClick = validateParScoreClick()
        if (disallowClick){
            return
        }
        
        let oversInn1Start : Double! = Double(team1OversStart.text!)
        let oversInn2Start : Double! = Double(team2OversStart.text!)
        let team2overs : Double! = Double(team2OversCurrent.text!)
        let team2Wkts : Int! = Int(team2Wickets.text!)
        
        let firstInning = Inning(inningPosition: 1, oversAtBeginning: oversInn1Start)
        let secondInning = Inning(inningPosition: 2, oversAtBeginning: oversInn2Start)
        
        firstInning?.finalScore = Int(team1FinalScore.text!)
//        firstInning?.wicketsLost = Int(team1Wickets.text!)
        firstInning?.interruptions = interruptionsTeam1
        firstInning?.oversReducedToLast = oversInn1Start //oversReducedToLast - confusing/wrong naming - correct it
        firstInning?.setResourcesAvail()
        
        secondInning?.overs = team2overs
        secondInning?.interruptions = interruptionsTeam2
        secondInning?.oversReducedToLast = oversInn2Start //oversReducedToLast - confusing/wrong naming - correct it
//        secondInning?.setResourcesAvail()
//        secondInning?.oversForTargetCalculation = overRedToInn2
//        secondInning?.setTarget(firstInning: firstInning!)
        
        secondInning?.addPrematureTermination(oversAtStop: team2overs, wickets: team2Wkts)
        secondInning?.setResourcesAvail()
        secondInning?.setParScore(firstInning: firstInning!)
        
        let parScoreText = secondInning?.getFormattedParScore()
        parScoreTextField.text = "\(String(describing: parScoreText!))/\(team2Wkts!)"
        parScoreOverLabel.text = "(\(team2overs!))"
        
//        let targetText = secondInning?.getFormattedTarget()
//        parScoreTextField.text = targetText
    }
    
    @IBAction func clickTargetButton(_ sender: Any) {
        
        let disallowClick = validateTargetClick()
        if (disallowClick){
            return
        }
        
        let oversInn1Start : Double! = Double(team1OversStart.text!)
        let oversInn2Start : Double! = Double(team2OversStart.text!)
        let team2overs : Double! = Double(team2OversCurrent.text!)
//        let team2Wkts : Int! = Int(team2Wickets.text!)
        
        let firstInning = Inning(inningPosition: 1, oversAtBeginning: oversInn1Start)
        let secondInning = Inning(inningPosition: 2, oversAtBeginning: oversInn2Start)
        
        firstInning?.finalScore = Int(team1FinalScore.text!)
//        firstInning?.wicketsLost = Int(team1Wickets.text!)
        firstInning?.interruptions = interruptionsTeam1
        firstInning?.oversReducedToLast = oversInn1Start //oversReducedToLast - confusing/wrong naming - correct it
        firstInning?.setResourcesAvail()
        
        secondInning?.overs = team2overs
        secondInning?.interruptions = interruptionsTeam2
        secondInning?.oversReducedToLast = oversInn2Start //oversReducedToLast - confusing/wrong naming - correct it
        secondInning?.setResourcesAvail()
        secondInning?.oversForTargetCalculation = overRedToInn2
        secondInning?.setTarget(firstInning: firstInning!)
        
//        secondInning?.addPrematureTermination(oversAtStop: team2overs, wickets: team2Wkts)
//        secondInning?.setResourcesAvail()
//        secondInning?.setParScore(firstInning: firstInning!)
        
        if !(interruptionsTeam2.count > 0){
            let team2overs = team2OversStart.text ?? ""
            guard let team2OversDouble = Double (team2overs) else {
                fatalError("team2overs not a double")
            }
            overRedToInn2 = team2OversDouble
        }
        
        let targetText = secondInning?.getFormattedTarget()
        targetTextField.text = targetText
        targetOversLabel.text = "(\(overRedToInn2))"
    }
    
    @IBAction func unwindToParScoreCalculator (sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? InterruptionsTableViewController {
            
            let interruptions = sourceViewController.interruptions
            
            if (sourceViewController.navigationItem.title == "First Innings"){
                interruptionsTeam1 = interruptions
            } else if (sourceViewController.navigationItem.title == "Second Innings"){
                interruptionsTeam2 = interruptions
                let count = interruptions.count
                if (count.distance(to: 0) != 0){
                    let finalIndex = interruptionsTeam2.count - 1
                    overRedToInn2 = interruptionsTeam2[finalIndex].oversReducedTo
                }//Add else condition to change overRedToInn2
            }
        }
    }
    
    //MARK: Private Functions
    private func validateParScoreClick() -> Bool{
        let team1overs = team1OversStart.text ?? ""
//        let team1wickets = team1Wickets.text ?? ""
        let team1score = team1FinalScore.text ?? ""
        let team2overs = team2OversStart.text ?? ""
        let team2wickets = team2Wickets.text ?? ""
        let team2oversCurrent = team2OversCurrent.text ?? ""
        
        let title = "Oops!!"
        var disallowClick = false
        var message = ""
        
        if (team1overs.isEmpty || team1score.isEmpty || team2overs.isEmpty || team2wickets.isEmpty || team2oversCurrent.isEmpty){
            message = "At least one required field is empty. Please fill all fields."
            disallowClick = true
        }
        
        if (!disallowClick){
            guard let team1OversDouble = Double (team1overs) else {
                fatalError("team1overs not a double")
            }
            guard let team2OversDouble = Double (team2overs) else {
                fatalError("team2overs not a double")
            }
            guard let team2OversCurrentDouble = Double (team2oversCurrent) else {
                fatalError("team2oversCurrent not a double")
            }
            
            if (team1OversDouble > 50.0 || team2OversDouble > 50.0 || team1OversDouble == 0.0 || team2OversDouble == 0.0 || team2OversCurrentDouble > 50.0 || team2OversCurrentDouble > 50.0){
                message = "Please enter valid value for overs. Valid values are between 0.1 and 50.0"
                disallowClick = true
            }
            
            if (!disallowClick) {
                if (team2OversDouble.isLess(than: team2OversCurrentDouble)) {
                    message = "Overs played so far in second innings cannot be more than overs alloted at start of innings."
                    disallowClick = true
                }
                
                if (!disallowClick) {
                    if (interruptionsTeam2.count > 0) {
                        let finalIndex = interruptionsTeam2.count - 1
                        let oversReducedToFinal = interruptionsTeam2[finalIndex].oversReducedTo
                        if (oversReducedToFinal.isLess(than: team2OversCurrentDouble)) {
                            message = "Overs played so far in second innings cannot be more than overs the innings was reduced to after the last interruption."
                            disallowClick = true
                        }
                    }
                }
            }
        }
        
        if (disallowClick){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        return disallowClick
    }
    
    private func validateTargetClick() -> Bool{
        let team1overs = team1OversStart.text ?? ""
//        let team1wickets = team1Wickets.text ?? ""
        let team1score = team1FinalScore.text ?? ""
        let team2overs = team2OversStart.text ?? ""
        
        let title = "Oops!!"
        var disallowClick = false
        var message = ""
        
        if (team1overs.isEmpty || team1score.isEmpty || team2overs.isEmpty){
            message = "Runs scored in Inning 1 is required to calculate target. Please fill the same"
            disallowClick = true
        }
        
        if (!disallowClick){
            guard let team1OversDouble = Double (team1overs) else {
                fatalError("team1overs not a double")
            }
            guard let team2OversDouble = Double (team2overs) else {
                fatalError("team2overs not a double")
            }
            
            if (team1OversDouble > 50.0 || team2OversDouble > 50.0 || team1OversDouble == 0.0 || team2OversDouble == 0.0){
                message = "Please enter valid value for overs. Valid values are between 0.1 and 50.0"
                disallowClick = true
            }
        }
        
        if (disallowClick){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        return disallowClick
    }
    
    private func setUpPickers() {
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        //WICKETS TEAM 1 ---------------------------------------------------------------------------------------------------------------
//        let wicketsTeam1PickerView = UIPickerView()
//        wicketsTeam1PickerView.delegate = self
//        wicketsTeam1PickerView.tag = wicketTeam1
//        wicketsTeam1PickerView.showsSelectionIndicator = true
//
//        let doneButtonWicketsTeam1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CalculatorViewController.donePickerWicketsTeam1))
//        let toolBarWicketsTeam1 = UIToolbar()
//        toolBarWicketsTeam1.barStyle = UIBarStyle.default
//        toolBarWicketsTeam1.isTranslucent = true
//        toolBarWicketsTeam1.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBarWicketsTeam1.sizeToFit()
//        toolBarWicketsTeam1.setItems([spaceButton, doneButtonWicketsTeam1], animated: false)
//        toolBarWicketsTeam1.isUserInteractionEnabled = true
//
//        team1Wickets.inputView = wicketsTeam1PickerView
//        team1Wickets.inputAccessoryView = toolBarWicketsTeam1
        
        //WICKETS TEAM 2 ---------------------------------------------------------------------------------------------------------------
        let wicketsTeam2PickerView = UIPickerView()
        wicketsTeam2PickerView.delegate = self
        wicketsTeam2PickerView.tag = wicketTeam2
        wicketsTeam2PickerView.showsSelectionIndicator = true
        
        let doneButtonWicketsTeam2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CalculatorViewController.donePickerWicketsTeam2))
        let toolBarWicketsTeam2 = UIToolbar()
        toolBarWicketsTeam2.barStyle = UIBarStyle.default
        toolBarWicketsTeam2.isTranslucent = true
        toolBarWicketsTeam2.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarWicketsTeam2.sizeToFit()
        toolBarWicketsTeam2.setItems([spaceButton, doneButtonWicketsTeam2], animated: false)
        toolBarWicketsTeam2.isUserInteractionEnabled = true
        
        team2Wickets.inputView = wicketsTeam2PickerView
        team2Wickets.inputAccessoryView = toolBarWicketsTeam2
        
        //OVERS TEAM 1 -----------------------------------------------------------------------------------------------------------------
        let oversTeam1PickerView = UIPickerView()
        oversTeam1PickerView.delegate = self
        oversTeam1PickerView.tag = overTeam1Start
        oversTeam1PickerView.showsSelectionIndicator = true
        oversTeam1PickerView.selectRow(50, inComponent: 0, animated: true)
        oversTeam1PickerView.selectRow(0, inComponent: 1, animated: true)
        
        let doneButtonOversTeam1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CalculatorViewController.donePickerOversTeam1))
        let toolBarOversTeam1 = UIToolbar()
        toolBarOversTeam1.barStyle = UIBarStyle.default
        toolBarOversTeam1.isTranslucent = true
        toolBarOversTeam1.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarOversTeam1.sizeToFit()
        toolBarOversTeam1.setItems([spaceButton, doneButtonOversTeam1], animated: false)
        toolBarOversTeam1.isUserInteractionEnabled = true
        
        team1OversStart.inputView = oversTeam1PickerView
        team1OversStart.inputAccessoryView = toolBarOversTeam1
        
        //OVERS TEAM 2 -----------------------------------------------------------------------------------------------------------------
        let oversTeam2PickerView = UIPickerView()
        oversTeam2PickerView.delegate = self
        oversTeam2PickerView.tag = overTeam2Start
        oversTeam2PickerView.showsSelectionIndicator = true
        oversTeam2PickerView.selectRow(50, inComponent: 0, animated: true)
        oversTeam2PickerView.selectRow(0, inComponent: 1, animated: true)
        
        let doneButtonOversTeam2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CalculatorViewController.donePickerOversTeam2))
        let toolBarOversTeam2 = UIToolbar()
        toolBarOversTeam2.barStyle = UIBarStyle.default
        toolBarOversTeam2.isTranslucent = true
        toolBarOversTeam2.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarOversTeam2.sizeToFit()
        toolBarOversTeam2.setItems([spaceButton, doneButtonOversTeam2], animated: false)
        toolBarOversTeam2.isUserInteractionEnabled = true
        
        team2OversStart.inputView = oversTeam2PickerView
        team2OversStart.inputAccessoryView = toolBarOversTeam2
        
        //CURRENT OVERS TEAM 2 ---------------------------------------------------------------------------------------------------------
        let oversTeam2CurrentPickerView = UIPickerView()
        oversTeam2CurrentPickerView.delegate = self
        oversTeam2CurrentPickerView.tag = overTeam2Current
        oversTeam2CurrentPickerView.showsSelectionIndicator = true
        
        let doneButtonCurrentOversTeam2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CalculatorViewController.donePickerCurrentOversTeam2))
        let toolBarCurrentOversTeam2 = UIToolbar()
        toolBarCurrentOversTeam2.barStyle = UIBarStyle.default
        toolBarCurrentOversTeam2.isTranslucent = true
        toolBarCurrentOversTeam2.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarCurrentOversTeam2.sizeToFit()
        toolBarCurrentOversTeam2.setItems([spaceButton, doneButtonCurrentOversTeam2], animated: false)
        toolBarCurrentOversTeam2.isUserInteractionEnabled = true
        
        team2OversCurrent.inputView = oversTeam2CurrentPickerView
        team2OversCurrent.inputAccessoryView = toolBarCurrentOversTeam2
        
        let doneButtonRuns = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CalculatorViewController.doneRuns))
        let toolBarRuns = UIToolbar()
        toolBarRuns.barStyle = UIBarStyle.default
        toolBarRuns.isTranslucent = true
        toolBarRuns.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarRuns.sizeToFit()
        toolBarRuns.setItems([spaceButton, doneButtonRuns], animated: false)
        toolBarRuns.isUserInteractionEnabled = true
        
        team1FinalScore.inputAccessoryView = toolBarRuns
    }
    
//    @objc private func donePickerWicketsTeam1() {
//        team1Wickets.resignFirstResponder()
//    }
    @objc private func donePickerWicketsTeam2() {
        team2Wickets.resignFirstResponder()
    }
    @objc private func donePickerOversTeam1() {
        team1OversStart.resignFirstResponder()
    }
    @objc private func donePickerOversTeam2() {
        team2OversStart.resignFirstResponder()
    }
    @objc private func donePickerCurrentOversTeam2() {
        team2OversCurrent.resignFirstResponder()
    }
    @objc private func doneRuns() {
        team1FinalScore.resignFirstResponder()
    }
}

