//
//  UISegmentedTableView.swift
//  temp
//
//  Created by Erick Sanchez on 5/6/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

@objc public protocol UISegmentedTableViewDataSource: class {
    func numberOfSegments(in segmentedTableView: UISegmentedTableView) -> Int
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, titleFor segmentIndex: Int) -> String
    
    @objc optional func numberOfTabs(in segmentedTableView: UISegmentedTableView) -> Int
    @objc optional func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tabFor index: Int) -> UISegmentedTableViewTabView
    
    @objc optional func segmentedTableView(_ segmentedTableView: UISegmentedTableView, numberOfSectionsIn tableView: UITableView) -> Int
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tableView: UITableView, numberOfRowsIn section: Int) -> Int
    func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    //TODO: more methods
}

@objc public protocol UISegmentedTableViewDelegate: class {
    
    @objc optional func segmentedTableView(_ segmentedTableView: UISegmentedTableView, didSelectAt selectedIndex: UISegmentedTableView.UISegmentedTableViewSelectedIndex)
    
    @objc optional func segmentedTableView(_ segmentedTableView: UISegmentedTableView, tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //TODO: support more methods
}

public class UISegmentedTableView: UIView {
    
    @IBOutlet public weak var tableDataSource: UITableViewDataSource?
    
    @IBOutlet public weak var tableDelegate: UITableViewDelegate?
    
    @IBOutlet public weak var dataSource: UISegmentedTableViewDataSource?
    
    @IBOutlet public weak var delegate: UISegmentedTableViewDelegate?
    
    public class UISegmentedTableViewSelectedIndex: NSObject {
        @objc public enum Source: Int {
            case SegmentButtons
            case TabButtons
        }
        
        public var source: Source
        public var index: Int
        
        public init(source: Source, index: Int) {
            self.source = source
            self.index = index
        }
    }
    
    //TODO: flat map the index values
    public private(set) var selectedIndex: UISegmentedTableViewSelectedIndex? {
        didSet {
            //TODO: make public set/get
            if let selectedIndex = self.selectedIndex {
                if selectedIndex.source == .SegmentButtons {
                    selectedButton = segmentButtons[selectedIndex.index]
                } else {
                    selectedButton = tabButtons[selectedIndex.index]
                }
            } else {
                selectedButton = nil
            }
        }
    }
    
    private var selectedButton: UIButton?
    
    public func setSelected(source: UISegmentedTableViewSelectedIndex.Source, index: Int) {
        let indexPair = UISegmentedTableViewSelectedIndex(source: source, index: index)
        
        //update the unselected button to be deselected
        if self.selectedIndex != nil {
            deselect(button: self.selectedButton!)
        }
        
        //update to the new index and update the button to be selected
        self.selectedIndex = indexPair
        
        select(button: selectedButton!)
        
    }
    
    private lazy var segmentButtons: [UIButton] = []
    
    private lazy var tabButtons: [UISegmentedTableViewTabView] = []
    
    public var selectedIndexColor: UIColor = .blue {
        didSet {
            //TODO: update button colors
        }
    }
    
    public var deselectedIndexColor: UIColor = .black {
        didSet {
            //TODO: update button colors
        }
    }
    
    public private(set) var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // MARK: - RETURN VALUES
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayout()
        reloadData()
    }
    
    // MARK: - VOID METHODS
    
    private var superviewStackView: UIStackView!
    
    private var segmentsScrollView = UIScrollView()
    
    private var segmentsStackView: UIStackView!
    
    private var tabsStackView: UIStackView!
    
    private func initLayout() {
        
        /** vertical stack view that contains all views (table view and header stackview) */
        superviewStackView = UIStackView(frame: bounds)
        superviewStackView.axis = .vertical
        
        //layout segments
        self.segmentsStackView = UIStackView()
        segmentsStackView.axis = .horizontal
        segmentsStackView.spacing = 8.0
        segmentsStackView.distribution = .equalSpacing
        segmentsStackView.alignment = .fill
        segmentsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20.0) // compared to system font, 17
        
        //insert segment stack view into scroll view
        segmentsScrollView.isScrollEnabled = true
        segmentsScrollView.alwaysBounceHorizontal = true
        segmentsScrollView.showsHorizontalScrollIndicator = false
        segmentsScrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        segmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentsScrollView.addSubview(segmentsStackView)
        segmentsStackView.leadingAnchor.constraint(equalTo: segmentsScrollView.leadingAnchor).isActive = true
        segmentsStackView.trailingAnchor.constraint(equalTo: segmentsScrollView.trailingAnchor).isActive = true
        segmentsStackView.topAnchor.constraint(equalTo: segmentsScrollView.topAnchor).isActive = true
        segmentsStackView.bottomAnchor.constraint(equalTo: segmentsScrollView.bottomAnchor).isActive = true
        segmentsScrollView.heightAnchor.constraint(equalTo: segmentsStackView.heightAnchor).isActive = true
        
        //layout tabs
        self.tabsStackView = UIStackView()
        tabsStackView.axis = .horizontal
        tabsStackView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        tabsStackView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        tabsStackView.alignment = .bottom
        tabsStackView.distribution = .fill
        tabsStackView.spacing = 12.0
        
        //layout headerStack and superview stack view
        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fill
        
        /** this view contains the scroll view allowing us to add a layer on top of the uiscroll view */
        let scrollViewContainer = UIView()
        segmentsScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollViewContainer.addSubview(segmentsScrollView)
        headerStackView.addArrangedSubview(scrollViewContainer)
        headerStackView.addArrangedSubview(tabsStackView)
        
        tabsStackView.heightAnchor.constraint(equalTo: segmentsScrollView.heightAnchor, multiplier: 1).isActive = true
        
        headerStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        superviewStackView.addArrangedSubview(headerStackView)
        
        //bottom black bar
        let bottomBarPath = UIBezierPath()
        bottomBarPath.move(to: CGPoint(x: 0, y: bounds.maxY))
        bottomBarPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        let bottomBarShape = CAShapeLayer()
        bottomBarShape.path = bottomBarPath.cgPath
        bottomBarShape.lineWidth = 1.0
        bottomBarShape.strokeColor = UIColor.blue.cgColor
        
        layer.addSublayer(bottomBarShape)
        
        tableView.dataSource = self.tableDataSource ?? self // allows the user to use either UITableViewDataSource or the limited supported methods in UISegmentedTableViewDataSource
        tableView.delegate = self.tableDelegate ?? self
    }
    
    public func reloadData() {
        guard let dataSource = self.dataSource else {
            return
        }
        
        //clear exsisting buttons
        segmentsStackView.subviews.removeAllFromSuperviews()
        tabsStackView.subviews.removeAllFromSuperviews()
        
        //Add segments to stack view
        for aSegmentIndex in 0..<dataSource.numberOfSegments(in: self) {
            let segmentTitle = dataSource.segmentedTableView(self, titleFor: aSegmentIndex)
            let segmentButton = UIButton(type: .system)
            segmentButton.setTitle(segmentTitle, for: .normal)
            segmentButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            let fontHeight = segmentButton.titleLabel!.font.pointSize
            segmentButton.heightAnchor.constraint(equalToConstant: fontHeight + 24.0).isActive = true

            //set selected index either to self.seletedIndex or to 0
            if aSegmentIndex == selectedIndex?.index ?? 0 {
                self.select(button: segmentButton)
                self.selectedButton = segmentButton
                //TODO: underline
            } else {
                self.deselect(button: segmentButton)
            }
            segmentButton.tag = aSegmentIndex
            segmentButton.addTarget(self, action: #selector(pressSegment(_:)), for: .touchUpInside)
            
            segmentsStackView.addArrangedSubview(segmentButton)
        }
        
        //store segment buttons
        self.segmentButtons = segmentsStackView.arrangedSubviews as! [UIButton]
        if self.segmentButtons.count != 0 {
            self.setSelected(source: .SegmentButtons, index: 0)
        } else {
            self.selectedIndex = nil
        }
        
        //Add tabs to stack view
        if let nTabs = dataSource.numberOfTabs?(in: self) {
            for aTabIndex in 0..<nTabs {
                let tab = dataSource.segmentedTableView!(self, tabFor: aTabIndex)
                tab.addTarget(self, action: #selector(pressTab(_:)), for: .touchUpInside)
                tab.tag = aTabIndex
                self.deselect(button: tab)
                
                tabsStackView.addArrangedSubview(tab)
            }
        }
        
        //store tab buttons
        self.tabButtons = tabsStackView.subviews as! [UISegmentedTableViewTabView]
        
        //layout table
        tableView.reloadData()
        
        superviewStackView.addArrangedSubview(tableView)
        
        superviewStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(superviewStackView)
    }
    
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    private func select(button: UIButton) {
        if let buttonTab = button as? UISegmentedTableViewTabView {
            buttonTab.tintColor = UIColor.white
            buttonTab.backgroundColor = self.selectedIndexColor
        } else {
            button.setTitleColor(self.selectedIndexColor, for: .normal)
        }
    }
    
    private func deselect(button: UIButton) {
        if let buttonTab = button as? UISegmentedTableViewTabView {
            buttonTab.tintColor = buttonTab.outlineColor
            buttonTab.backgroundColor = nil
        } else {
            button.setTitleColor(self.deselectedIndexColor, for: .normal)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        //fade left and right edges of scroll view
        let gradientMaskLayer: CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.frame = segmentsScrollView.bounds
        let colors: [UIColor] = [.clear, .black, .black, .clear]
        gradientMaskLayer.colors = colors.map { $0.cgColor }
        let paddingSize: Float = 16.0
        let paddingSizePercent: Float = paddingSize / Float(segmentsScrollView.bounds.width)
        gradientMaskLayer.locations = [0.0, NSNumber(value: paddingSizePercent), NSNumber(value: 1.0 - paddingSizePercent), 1.0]
        gradientMaskLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientMaskLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
//        segmentsScrollView.superview!.layer.mask = gradientMaskLayer
    }
    
    // MARK: - IBACTIONS
    
    @objc private func pressSegment(_ segmentButton: UIButton) {
        self.setSelected(source: .SegmentButtons, index: segmentButton.tag)
        delegate?.segmentedTableView?(self, didSelectAt: self.selectedIndex!)
        reloadTableView()
    }
    
    @objc private func pressTab(_ tabButton: UISegmentedTableViewTabView) {
        self.setSelected(source: .TabButtons, index: tabButton.tag)
        delegate?.segmentedTableView?(self, didSelectAt: self.selectedIndex!)
        reloadTableView()
    }
    
    // MARK: - LIFE CYCLE

}

extension UISegmentedTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.segmentedTableView?(self, numberOfSectionsIn: tableView) ?? 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource!.segmentedTableView(self, tableView: tableView, numberOfRowsIn: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dataSource!.segmentedTableView(self, tableView: tableView, cellForRowAt: indexPath)
    }
}

extension UISegmentedTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.segmentedTableView?(self, tableView: tableView, didSelectRowAt: indexPath)
    }
}

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension Array where Element : UIView {
    func removeAllFromSuperviews() {
        forEach { $0.removeFromSuperview() }
    }
}

