//
//  settingsViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 11.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var themeTableView: UITableView!

    @IBOutlet weak var fastSlow: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeTableView.delegate = self
        themeTableView.dataSource = self
        
        fastSlow.selectedSegmentIndex = Model.shared.fastResponseTime
        
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
        let indexPath = IndexPath(row: Model.shared.themeIndex, section: 0)
        themeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    @IBAction func fastSlowChanged(_ sender: Any) {
        if let fastSlow = sender as? UISegmentedControl {
            Model.shared.fastResponseTime = fastSlow.selectedSegmentIndex
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Model.shared.themeIndex = indexPath.row
        tableView.reloadData()
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Theme" } else { return nil }
    }
    
    @objc func showDetail() {
        let indexPath = IndexPath(row: Model.shared.themeIndex, section: 0)
        if Model.shared.theme(index: indexPath.row).readonly || Model.shared.customizationHasBeenPurchased {
            performSegue(withIdentifier: "displaySettingsSegue", sender: indexPath)
        } else {
            performSegue(withIdentifier: "purchaseSegue", sender: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showDetail()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath)
        
        if indexPath.row == Model.shared.themeIndex {
            if Model.shared.theme().readonly {
                cell.accessoryType = .detailButton
                cell.tintColor = bullshitRed
                cell.accessoryView = nil
            } else {
                cell.accessoryType = .none
                cell.accessoryType = .none
                cell.accessoryType = UITableViewCell.AccessoryType.none
                let b = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
                b.setTitle("Edit", for: .normal)
                b.setTitleColor(bullshitRed, for: .normal)
                b.contentHorizontalAlignment = .right
                b.addTarget(self, action: #selector(showDetail), for: .touchDown)
                cell.accessoryView = b
            }
        } else {
            cell.accessoryType = .none
            cell.accessoryView = nil
        }
        
        cell.textLabel?.text = Model.shared.themeName(n: indexPath.row)
        return cell
    }
    
}
