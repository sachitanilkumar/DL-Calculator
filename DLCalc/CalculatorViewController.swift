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
    let overTeam1 = 3
    let overTeam2 = 4
    
    let wicketsTeam1 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let wicketsTeam2 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let oversTeam1 = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["0", "1", "2", "3", "4", "5"]]
    let oversTeam2 = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["0", "1", "2", "3", "4", "5"]]
    
    //MARK: Properties
    @IBOutlet weak var team1Overs: UITextField!
    @IBOutlet weak var team1Wickets: UITextField!
    @IBOutlet weak var team1FinalScore: UITextField!
    @IBOutlet weak var team2Overs: UITextField!
    @IBOutlet weak var team2Wickets: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var parScoreTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGoButtonState()
        
        team1Overs.delegate = self
        team1Wickets.delegate = self
        team1FinalScore.delegate = self
        team2Overs.delegate = self
        team2Wickets.delegate = self
        
        let wicketsTeam1PickerView = UIPickerView()
        wicketsTeam1PickerView.delegate = self
        wicketsTeam1PickerView.tag = wicketTeam1
        team1Wickets.inputView = wicketsTeam1PickerView
        
        let wicketsTeam2PickerView = UIPickerView()
        wicketsTeam2PickerView.delegate = self
        wicketsTeam2PickerView.tag = wicketTeam2
        team2Wickets.inputView = wicketsTeam2PickerView
        
        let oversTeam1PickerView = UIPickerView()
        oversTeam1PickerView.delegate = self
        oversTeam1PickerView.tag = overTeam1
        team1Overs.inputView = oversTeam1PickerView
        
        let oversTeam2PickerView = UIPickerView()
        oversTeam2PickerView.delegate = self
        oversTeam2PickerView.tag = overTeam2
        team2Overs.inputView = oversTeam2PickerView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        goButton.isEnabled = false
        parScoreTextField.text = "The D/L Par Score is: "
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateGoButtonState()
    }
    
    //MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var components = 0
        if (pickerView.tag == wicketTeam1 || pickerView.tag == wicketTeam2){
            components = 1
        } else if (pickerView.tag == overTeam1 || pickerView.tag == overTeam2){
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
        if pickerView.tag == overTeam1 {
            return oversTeam1[component].count
        }
        if pickerView.tag == overTeam2 {
            return oversTeam2[component].count
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
        if pickerView.tag == overTeam1 {
            return oversTeam1[component][row]
        }
        if pickerView.tag == overTeam2 {
            return oversTeam2[component][row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == wicketTeam1 {
            team1Wickets.text = wicketsTeam1[row]
        }
        if pickerView.tag == wicketTeam2 {
            team2Wickets.text = wicketsTeam2[row]
        }
        if pickerView.tag == overTeam1 {
            let overs = oversTeam1[0][pickerView.selectedRow(inComponent: 0)]
            let balls = oversTeam1[1][pickerView.selectedRow(inComponent: 1)]
            team1Overs.text = overs + "." + balls
        }
        if pickerView.tag == overTeam2 {
            let overs = oversTeam2[0][pickerView.selectedRow(inComponent: 0)]
            let balls = oversTeam2[1][pickerView.selectedRow(inComponent: 1)]
            team2Overs.text = overs + "." + balls
        }
        
    }

    
    //MARK: Actions
    @IBAction func clickGoButton(_ sender: UIButton) {
        
        let totalOvers : Double! = Double(team1Overs.text!)
        let team2Ovrs : Double! = Double(team2Overs.text!)
        let team2Wkts : Int! = Int(team2Wickets.text!)
        
        var firstInning = Inning(inningPosition: 1, oversAtBeginning: totalOvers)
        var secondInning = Inning(inningPosition: 2, oversAtBeginning: totalOvers)
        
        firstInning?.finalScore = Int(team1FinalScore.text!)
        firstInning?.wicketsLost = Int(team1Wickets.text!)
        firstInning?.setResourcesAvail()
        
        secondInning?.overs = team2Ovrs
        secondInning?.addPrematureTermination(oversAtStop: team2Ovrs, wickets: team2Wkts)
        secondInning?.setResourcesAvail()
        secondInning?.setParScore(firstInning: firstInning!)
        
        let parScoreText = secondInning?.getFormattedParScore()
        parScoreTextField.text = parScoreText
    }
    
    //MARK: Private Functions
    private func updateGoButtonState() {
        // Disable the Save button if the text field is empty.
        let team1overs = team1Overs.text ?? ""
        let team1wickets = team1Wickets.text ?? ""
        let team1score = team1FinalScore.text ?? ""
        let team2overs = team2Overs.text ?? ""
        let team2wickets = team2Wickets.text ?? ""
        
        var enableGoButton = true
        if (team1overs.isEmpty || team1wickets.isEmpty || team1score.isEmpty || team2overs.isEmpty || team2wickets.isEmpty){
            enableGoButton = false
            goButton.isEnabled = enableGoButton
//            errorMessageLabel.text = "Please enter values in all fields"
            return
        }
        
        guard let team1OversDouble = Double (team1overs) else {
            enableGoButton = false
            goButton.isEnabled = enableGoButton
            return
        }
        guard let team2OversDouble = Double (team2overs) else {
            enableGoButton = false
            goButton.isEnabled = enableGoButton
            return
        }
        
        if (team1OversDouble > 50.0 || team2OversDouble > 50.0 || team1OversDouble == 0.0 || team2OversDouble == 0.0){
            enableGoButton = false
            goButton.isEnabled = enableGoButton
//            errorMessageLabel.text = "Please enter valid value for overs"
            return
        }
        
        goButton.isEnabled = enableGoButton
    }
    
    internal func subtractOvers (first: Double, second: Double) -> Double{
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

}

