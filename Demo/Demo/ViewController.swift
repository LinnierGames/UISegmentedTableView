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
    
    enum Cases: Int {
        case AllData
        case NoSegments
        case NoTabs
        case NoRows
        case OnlySegments
        case OnlyTabs
        case OnlyRows
        case NoData
        
        static var allCases: [Cases] {
            return [.AllData, .NoSegments, .NoTabs, .NoRows, .OnlySegments, .OnlyTabs, .OnlyRows, .NoData]
        }
    }
    
    private var segmentTitles = [String]()
    
    private var contents = [[String]]()
    
    private var tabIcons = [UIImage]() //= [#imageLiteral(resourceName: "clock"), #imageLiteral(resourceName: "checkoff")]
    
    private var tabContents = [[String]]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl! {
        didSet {
            segmentControl.removeAllSegments()
            
            for aCase in Cases.allCases.reversed() {
                segmentControl.insertSegment(withTitle: String(describing: aCase), at: 0, animated: false)
            }
            
            segmentControl.selectedSegmentIndex = 0
        }
    }
    @IBAction func changeSegmentControl(_ sender: Any) {
        let _case = Cases(rawValue: segmentControl.selectedSegmentIndex)!
        
        switch _case {
        case .AllData:
            self.segmentTitles = ["Today", "Tomorrow", "No Deadline"]
            self.contents = [["today", "today", "today", "today"], [], ["no deadline", "no deadline", "no deadline"]]
            self.tabIcons = [#imageLiteral(resourceName: "clock"), #imageLiteral(resourceName: "checkoff")]
            self.tabContents = [["overdue", "overdue", "overdue"], ["done", "done", "done"]]
        case .NoSegments:
            self.segmentTitles = []
            self.contents = [["today", "today", "today", "today"]]
            self.tabIcons = [#imageLiteral(resourceName: "clock"), #imageLiteral(resourceName: "checkoff")]
            self.tabContents = [["overdue", "overdue", "overdue"], ["done", "done", "done"]]
        case .NoTabs:
            self.segmentTitles = ["Today", "Tomorrow", "No Deadline"]
            self.contents = [["today", "today", "today", "today"], [], ["no deadline", "no deadline", "no deadline"]]
            self.tabIcons = []
            self.tabContents = []
        case .NoRows:
            self.segmentTitles = ["Today", "Tomorrow", "No Deadline"]
            self.contents = [[], [], []]
            self.tabIcons = [#imageLiteral(resourceName: "clock"), #imageLiteral(resourceName: "checkoff")]
            self.tabContents = [[], []]
        case .OnlySegments:
            self.segmentTitles = ["Today", "Tomorrow", "No Deadline"]
            self.contents = [[], [], []]
            self.tabIcons = []
            self.tabContents = [[], []]
        case .OnlyTabs:
            self.segmentTitles = []
            self.contents = [[], [], []]
            self.tabIcons = [#imageLiteral(resourceName: "clock"), #imageLiteral(resourceName: "checkoff")]
            self.tabContents = [[], []]
        case .OnlyRows:
            self.segmentTitles = []
            self.contents = [["today", "today", "today", "today"]]
            self.tabIcons = []
            self.tabContents = []
        case .NoData:
            self.segmentTitles = []
            self.contents = []
            self.tabIcons = []
            self.tabContents = []
        }
        
        tableView.reloadData()
    }
    
    // MARK: - LIFE CYCLE
}




