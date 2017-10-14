//
//  interruptionsTableViewController
//  DLCalc
//
//  Created by Sachit Anil Kumar on 08/10/17.
//  Copyright © 2017 Sachit Anil Kumar. All rights reserved.
//

import UIKit
import os.log

class InterruptionsTableViewController: UITableViewController {
    
    var interruptions = [Interruption]()
    var titleName = ""
    var oversInInnings: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = titleName
        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interruptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "interruptionCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InterruptionTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let interruption = interruptions[indexPath.row]
        cell.interruptionLabel.text = "Interruption at \(interruption.oversAtSuspension) overs with \(interruption.wicketsAtSuspension) wickets down. Play resumed with innings shortened to \(interruption.oversReducedTo) overs."
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            interruptions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "saveInterruptionsList"{
                var oversMin = 0.1
                var oversMax = oversInInnings
                var wickets = 0
                
                let count = interruptions.count
                if (count.distance(to: 0) != 0){
                    for index in 0...(count - 1) {
                        let interruption = interruptions[index]
                        
                        if (interruption.oversAtSuspension.isLess(than: oversMin)){
                            if index == 0 {
                                let alertController = UIAlertController(title: "Oops!!", message: "Overs for the start of an interruption cannot be lower than 0.1. Please correct the same.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                                return false
                            } else {
                                let alertController = UIAlertController(title: "Oops!!", message: "Overs for the start of a later interruption cannot be lower than that of a previous interruption. Please correct the same.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                                return false
                            }
                        } else if (oversMax?.isLess(than: interruption.oversReducedTo))!{
                            if index == 0 {
                                let alertController = UIAlertController(title: "Oops!!", message: "Overs that the innings has been reduced to cannot be greater than what was alloted at the start of the innings. Please correct the same.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                                return false
                            } else {
                                let alertController = UIAlertController(title: "Oops!!", message: "Overs that the innings has been reduced to cannot be greater that what it was earlier reduced to due to a previous interruption. Please correct the same.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                                return false
                            }
                        } else if (interruption.wicketsAtSuspension < wickets) {
                            let alertController = UIAlertController(title: "Oops!!", message: "Wickets that have been lost at the start of a later interruption cannot be lower than wickets that were lost at the start of a previous interruption. Please correct the same.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return false
                        }
                        
                        oversMin = interruption.oversAtSuspension
                        oversMax = interruption.oversReducedTo
                        wickets = interruption.wicketsAtSuspension
                    }
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "addInterruption":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "showDetail":
            guard let interruptionViewController = segue.destination as? InterruptionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedInterruptionCell = sender as? InterruptionTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedInterruptionCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedInterruption = interruptions[indexPath.row]
            interruptionViewController.interruption = selectedInterruption
            interruptionViewController.idx = indexPath.row + 1
        case "saveInterruptionsList":
            os_log("Saving interruptions", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    //MARK: Actions
    @IBAction func unwindToInterruptionsList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? InterruptionViewController, let interruption = sourceViewController.interruption {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing interruption.
                interruptions[selectedIndexPath.row] = interruption
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Create a new interruption.
                let newIndexPath = IndexPath(row: interruptions.count, section: 0)
                interruptions.append(interruption)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Private Methods

}
