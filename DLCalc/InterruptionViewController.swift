//
//  InterruptionViewController.swift
//  DLCalc
//
//  Created by Sachit Anil Kumar on 09/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import UIKit
import os.log

class InterruptionViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    let wkt = 1
    let overSusp = 3
    let overRedTo = 4
    
    let wkts = ["","0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var oversSusp = [["","0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["","0", "1", "2", "3", "4", "5"]]
    var oversRedTo = [["","0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"],["","0", "1", "2", "3", "4", "5"]]
    
    //MARK: Properties
    @IBOutlet weak var oversAtSuspension: UITextField!
    @IBOutlet weak var wicketsAtSuspension: UITextField!
    @IBOutlet weak var oversReducedTo: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var interruption: Interruption?
    var idx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        oversAtSuspension.delegate = self
        wicketsAtSuspension.delegate = self
        oversReducedTo.delegate = self
        
        setUpPickers()
        
        if let interruption = interruption {
            oversAtSuspension.text = String(interruption.oversAtSuspension)
            wicketsAtSuspension.text = String(interruption.wicketsAtSuspension)
            oversReducedTo.text = String(interruption.oversReducedTo)
            navigationItem.title = "Interruption \(idx!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var components = 0
        if (pickerView.tag == wkt){
            components = 1
        } else if (pickerView.tag == overSusp || pickerView.tag == overRedTo){
            components =  2
        }
        return components
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == wkt {
            return wkts.count
        }
        if pickerView.tag == overSusp {
            return oversSusp[component].count
        }
        if pickerView.tag == overRedTo {
            return oversRedTo[component].count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == wkt {
            return wkts[row]
        }
        if pickerView.tag == overSusp {
            return oversSusp[component][row]
        }
        if pickerView.tag == overRedTo {
            return oversRedTo[component][row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == wkt {
            if wkts[row] == "" {
                pickerView.selectRow(row + 1, inComponent: 0, animated: true)
                wicketsAtSuspension.text = wkts[row + 1]
            } else {
                wicketsAtSuspension.text = wkts[row]
            }
        }
        if pickerView.tag == overSusp {
            var overs = oversSusp[0][pickerView.selectedRow(inComponent: 0)]
            var balls = oversSusp[1][pickerView.selectedRow(inComponent: 1)]
            if (overs == oversSusp[0][oversSusp[0].count-1] && 0 != Int(balls)){
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
            oversAtSuspension.text = overs + "." + balls
        }
        if pickerView.tag == overRedTo {
            var overs = oversRedTo[0][pickerView.selectedRow(inComponent: 0)]
            var balls = oversRedTo[1][pickerView.selectedRow(inComponent: 1)]
            if (overs == oversRedTo[0][oversRedTo[0].count-1] && 0 != Int(balls)){
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
            oversReducedTo.text = overs + "." + balls
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let oversAtSusp : Double! = Double(oversAtSuspension.text!)
        let wicketsAtSusp : Int! = Int(wicketsAtSuspension.text!)
        let oversRedTo : Double! = Double(oversReducedTo.text!)
        
        interruption = Interruption(oversAtSuspension: oversAtSusp, oversReducedTo: oversRedTo, wicketsAtSuspension: wicketsAtSusp)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "saveInterruption" {
                let oversAtSusp = oversAtSuspension.text ?? ""
                let wicketsAtSusp = wicketsAtSuspension.text ?? ""
                let oversRedTo = oversReducedTo.text ?? ""
                
                let oversAtSuspDouble : Double! = Double(oversAtSuspension.text!)
//                let wicketsAtSuspInt : Int! = Int(wicketsAtSuspension.text!)
                let oversRedToDouble : Double! = Double(oversReducedTo.text!)
                
                if (oversAtSusp.isEmpty || wicketsAtSusp.isEmpty || oversRedTo.isEmpty){
                    let alertController = UIAlertController(title: "Oops!!", message: "At least one required field is empty. Please fill all fields.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
                
                if (oversRedToDouble.isLessThanOrEqualTo(oversAtSuspDouble)){
                    let alertController = UIAlertController(title: "Oops!!", message: "Overs reduced to must be greater than the overs already played before the interruption.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
            }
        }
        return true
    }
    
    //MARK: Action
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        if self.isModal() == true {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The InterruptionViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: Private Methods
    private func isModal() -> Bool {
        if((self.presentingViewController) != nil) {
            return true
        }
        if(self.presentingViewController?.presentedViewController == self) {
            return true
        }
        if(self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) {
            return true
        }
        if((self.tabBarController?.presentingViewController?.isKind(of: InterruptionsTableViewController.self)) != nil) {
            return true
        }
        return false
    }
    
    private func setUpPickers() {
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        // WICKETS -----------------------------------------------------------------------------------------------------------------
        let wicketsPickerView = UIPickerView()
        wicketsPickerView.delegate = self
        wicketsPickerView.tag = wkt
        wicketsPickerView.showsSelectionIndicator = true
        
        let doneButtonWickets = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(InterruptionViewController.donePickerWickets))
        doneButtonWickets.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        let toolBarWickets = UIToolbar()
        toolBarWickets.barStyle = UIBarStyle.default
        toolBarWickets.isTranslucent = true
        toolBarWickets.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarWickets.sizeToFit()
        toolBarWickets.setItems([spaceButton, doneButtonWickets], animated: false)
        toolBarWickets.isUserInteractionEnabled = true
        
        wicketsAtSuspension.inputView = wicketsPickerView
        wicketsAtSuspension.inputAccessoryView = toolBarWickets
        
        // OVERS AT SUSPENSION ------------------------------------------------------------------------------------------------------
        let oversSuspPickerView = UIPickerView()
        oversSuspPickerView.delegate = self
        oversSuspPickerView.tag = overSusp
        oversSuspPickerView.showsSelectionIndicator = true
        
        let doneButtonOversSusp = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(InterruptionViewController.donePickerOversSusp))
        doneButtonOversSusp.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        let toolBarOversSusp = UIToolbar()
        toolBarOversSusp.barStyle = UIBarStyle.default
        toolBarOversSusp.isTranslucent = true
        toolBarOversSusp.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarOversSusp.sizeToFit()
        toolBarOversSusp.setItems([spaceButton, doneButtonOversSusp], animated: false)
        toolBarOversSusp.isUserInteractionEnabled = true
        
        oversAtSuspension.inputView = oversSuspPickerView
        oversAtSuspension.inputAccessoryView = toolBarOversSusp
        
        // OVERS REDUCED TO ---------------------------------------------------------------------------------------------------------
        let oversRedToPickerView = UIPickerView()
        oversRedToPickerView.delegate = self
        oversRedToPickerView.tag = overRedTo
        oversRedToPickerView.showsSelectionIndicator = true
        
        let doneButtonOversRedTo = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(InterruptionViewController.donePickerOversRedTo))
        doneButtonOversRedTo.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        let toolBarOversRedTo = UIToolbar()
        toolBarOversRedTo.barStyle = UIBarStyle.default
        toolBarOversRedTo.isTranslucent = true
        toolBarOversRedTo.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBarOversRedTo.sizeToFit()
        toolBarOversRedTo.setItems([spaceButton, doneButtonOversRedTo], animated: false)
        toolBarOversRedTo.isUserInteractionEnabled = true
        
        oversReducedTo.inputView = oversRedToPickerView
        oversReducedTo.inputAccessoryView = toolBarOversRedTo
    }
    
    @objc private func donePickerWickets() {
        wicketsAtSuspension.resignFirstResponder()
    }
    @objc private func donePickerOversSusp() {
        oversAtSuspension.resignFirstResponder()
    }
    @objc private func donePickerOversRedTo() {
        oversReducedTo.resignFirstResponder()
    }
}
