//
//  ThemeTableViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 07.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class ThemeTableViewController: UITableViewController {
    
    @IBOutlet var themeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
            // simulator no in-app-purchase possible --> set as purchased
            Model.shared.customizationHasBeenPurchased = true
        #else
        #endif
        
        // for Debugging: set purchased to false
        // Model.shared.customizationHasBeenPurchased = false


        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        themeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "themeCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        themeTableView.selectRow(at: IndexPath(row: Model.shared.themeIndex, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Model.shared.themeIndex = indexPath.row
        tableView.reloadData()
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Theme" } else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if Model.shared.theme(index: indexPath.row).readonly || Model.shared.customizationHasBeenPurchased {
            performSegue(withIdentifier: "displaySettingsSegue", sender: indexPath)
        } else {
            performSegue(withIdentifier: "purchaseSegue", sender: indexPath)
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(#function) --- section = \(indexPath.section), row = \(indexPath.row)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath)
        
        cell.textLabel?.textColor = UIColor.black
        if !Model.shared.theme(index: indexPath.row).readonly {
            if !Model.shared.customizationHasBeenPurchased {
                cell.selectionStyle = .none;
                cell.textLabel?.textColor = UIColor.lightGray
            }
        }

        if indexPath.row == Model.shared.themeIndex {
            cell.accessoryType = .detailButton
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = Model.shared.themeName(n: indexPath.row)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySettingsSegue" {
            if let indexPath = sender as? IndexPath {
                if let destinationVC = segue.destination as? CustomViewController {
                    destinationVC.theme = Model.shared.theme(index: indexPath.row)
                }
            }
        }
        if segue.identifier == "purchaseSegue" {
            if let indexPath = sender as? IndexPath {
                if let destinationVC = segue.destination as? PurchaseViewController {
                    destinationVC.theme = Model.shared.theme(index: indexPath.row)
                }
            }
        }
    }

}
