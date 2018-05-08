//
//  ViewController.swift
//  Demo
//
//  Created by Erick Sanchez on 5/7/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit
import UISegmentedTableView

class ViewController: UIViewController, UISegmentedTableViewDataSource {
    
    
    private var segmentTitles = ["Today", "Next 7 Days", "No Deadlines"]
    
    private var contents = [
        [
            "Today",
            "Today",
            "Today",
            "Today",
            "Today",
            "Today",
            "Today"
        ],
        [
            "7 Days",
            "7 Days",
            "7 Days",
            "7 Days",
            "7 Days"
        ],
        [
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline",
            "No Deadline"
        ]
    ]
    
    @IBOutlet weak var tableView: UISegmentedTableView! {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - RETURN VALUES
    
    func numberOfSegments(in segmentedTableView: UISegmentedTableView) -> Int {
        return segmentTitles.count
    }
    
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, titleFor segmentIndex: Int) -> String {
        return segmentTitles[segmentIndex]
    }
    
    private var tabIcons = [#imageLiteral(resourceName: "clock"), #imageLiteral(resourceName: "checkoff")]
    
    private var tabContents = [
        [
            "Overdue",
            "Overdue",
            "Overdue",
            "Overdue",
            "Overdue"
        ],
        [
            "Copmleted",
            "Copmleted",
            "Copmleted"
        ]
    ]
    
    func numberOfTabs(in segmentedTableView: UISegmentedTableView) -> Int {
        return tabIcons.count
    }
    
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tabFor index: Int) -> UISegmentedTableViewTabView {
        let icon = tabIcons[index]
        let contents = tabContents[index]
        
        let tab = UISegmentedTableViewTabView(icon: icon, tintColor: .red)
        
        tab.badgeText = String(contents.count)
        
        return tab
    }
    
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, numberOfSectionsIn tableView: UITableView) -> Int {
        return 1
    }
    
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tableView: UITableView, numberOfRowsIn section: Int) -> Int {
        switch segmentedTableView.selectedIndex!.source {
        case .SegmentButtons:
            return contents[segmentedTableView.selectedIndex!.index].count
        case .TabButtons:
            return tabContents[segmentedTableView.selectedIndex!.index].count
        }
    }
    
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch segmentedTableView.selectedIndex!.source {
        case .SegmentButtons:
            let content = self.contents[segmentedTableView.selectedIndex!.index][indexPath.row]
            cell.textLabel!.text = content
        case .TabButtons:
            let content = self.tabContents[segmentedTableView.selectedIndex!.index][indexPath.row]
            cell.textLabel!.text = content
        }
        
        
        return cell
    }
    
    // MARK: - VOID METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
}



