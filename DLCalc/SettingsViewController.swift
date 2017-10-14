//
//  SettingsViewController.swift
//  DLCalc
//
//  Created by Sachit Anil Kumar on 07/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var dlsMethodSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreSwitchesStates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func toggleDlsSwitch(_ sender: UISwitch) {
        let isDLSMethodOn = dlsMethodSwitch!.isOn
        UserDefaults.standard.set(isDLSMethodOn, forKey: "DLSMethod");
        UserDefaults.standard.synchronize()
    }
    
    //MARK: Private Methods
    func restoreSwitchesStates() {
        let isDLSMethodOn = UserDefaults.standard.bool(forKey: "DLSMethod")
        dlsMethodSwitch!.isOn = isDLSMethodOn
    }
}

