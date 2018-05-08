//
//  UISegmentedTableView.swift
//  temp
//
//  Created by Erick Sanchez on 5/6/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

//open class UISegmentedTableViewTabViewTRASH: UIView {
//
//    var type: UISegmentedTableViewTabType
//
//    public var badgeValue: Int? = nil
//
//    public private(set) var icon: UIImage?
//
//    public private(set) var title: String?
//
//    public private(set) var tint: UIColor
//
//    fileprivate weak var delegate: UISegmentedTableViewTabViewDelegate!
//
//    private var bgButton: UIButton!
//
//    @objc public enum UISegmentedTableViewTabType: Int {
//        case Icon
//        case Title
//    }
//
//    public init(icon: UIImage, tint: UIColor) {
//        self.type = .Icon
//        self.icon = icon
//        self.tint = tint
//        super.init(frame: CGRect.zero)
//
//        self.initLayout()
//    }
//
//    public init(title: String, tint: UIColor) {
//        self.type = .Title
//        self.title = title
//        self.tint = tint
//        super.init(frame: CGRect.zero)
//
//        self.initLayout()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        self.type = .Icon
//        self.tint = .black
//        super.init(coder: aDecoder)
//
//        self.initLayout()
//    }
//
//    private func initLayout() {
//        switch self.type {
//        case .Icon:
//            let imageView = UIImageView(image: self.icon!)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            let constraintHeightWidthRatio = NSLayoutConstraint(
//                item: imageView,
//                attribute: .height,
//                relatedBy: .equal,
//                toItem: imageView,
//                attribute: .width,
//                multiplier: 1,
//                constant: 0
//            )
//            imageView.addConstraint(constraintHeightWidthRatio)
//            constraintHeightWidthRatio.isActive = true
//
//            bgButton = UIButton(type: .custom)
//            bgButton.layer.backgroundColor = UIColor.cyan.cgColor
//
//            bgButton.addTarget(self, action: #selector(press(_:)), for: .touchUpInside)
//
//            bgButton.translatesAutoresizingMaskIntoConstraints = false
//            addSubview(bgButton)
//
//            bgButton.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
//            bgButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//            bgButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            bgButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//            addSubview(imageView)
//            imageView.topAnchor.constraint(equalTo: bgButton.topAnchor, constant: 0).isActive = true
//            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4.0).isActive = true
//            trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4.0).isActive = true
//
//        case .Title:
//            break
//        }
//    }
//
//    // MARK: - RETURN VALUES
//
//    // MARK: - VOID METHODS
//
//    // MARK: - IBACTIONS
//
//    @objc private func press(_ button: UIButton) {
//        delegate.segmentedTableViewTabView(self, didSelectAt: button.tag)
//    }
//
//    // MARK: - LIFE CYCLE
//
//}

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
    
//    @objc optional func segmentedTableView(_ segmentedTableView: UISegmentedTableView, didSelectSegmentAt index: Int)
//
//    @objc optional func segmentedTableView(_ segmentedTableView: UISegmentedTableView, didSelectTabAt index: Int)
    
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
    
    private var selectedButton: UIButton? {
        didSet {
//            //
//            oldValue?.setTitleColor(self.deselectedIndexColor, for: .normal)
//            selectedButton.setTitleColor(self.selectedIndexColor, for: .normal)
        }
    }
    
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
    
    private var segmentsScrollView = UIScrollView()
    
    // MARK: - RETURN VALUES
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        reloadData()
    }
    
    // MARK: - VOID METHODS
    
    public func reloadData() {
        guard let dataSource = self.dataSource else {
            return
        }
        
        let superviewStackView = UIStackView(frame: bounds)
        superviewStackView.axis = .vertical
        
        //layout segments
        let segmentStackView = UIStackView()
        segmentStackView.axis = .horizontal
        segmentStackView.spacing = 8.0
        segmentStackView.distribution = .equalSpacing
        segmentStackView.alignment = .fill
        
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
            
            segmentStackView.addArrangedSubview(segmentButton)
        }
        self.segmentButtons = segmentStackView.arrangedSubviews as! [UIButton]
        if self.segmentButtons.count != 0 {
            self.setSelected(source: .SegmentButtons, index: 0)
        } else {
            self.selectedIndex = nil
        }
        
        
        //layout segments in a scroll view
        segmentsScrollView.isScrollEnabled = true
        segmentsScrollView.alwaysBounceHorizontal = true
        segmentsScrollView.showsHorizontalScrollIndicator = false
        segmentsScrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        segmentStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentsScrollView.addSubview(segmentStackView)
        segmentStackView.leadingAnchor.constraint(equalTo: segmentsScrollView.leadingAnchor).isActive = true
        segmentStackView.trailingAnchor.constraint(equalTo: segmentsScrollView.trailingAnchor).isActive = true
        segmentStackView.topAnchor.constraint(equalTo: segmentsScrollView.topAnchor).isActive = true
        segmentStackView.bottomAnchor.constraint(equalTo: segmentsScrollView.bottomAnchor).isActive = true
        segmentsScrollView.heightAnchor.constraint(equalTo: segmentStackView.heightAnchor).isActive = true
        
        //layout tabs
        let tabsStackView = UIStackView()
        tabsStackView.axis = .horizontal
        tabsStackView.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        tabsStackView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        tabsStackView.alignment = .bottom
        tabsStackView.distribution = .fill
        tabsStackView.spacing = 12.0
        
        if let nTabs = dataSource.numberOfTabs?(in: self) {
            for aTabIndex in 0..<nTabs {
                let tab = dataSource.segmentedTableView!(self, tabFor: aTabIndex)
                tab.addTarget(self, action: #selector(press(_:)), for: .touchUpInside)
                tab.tag = aTabIndex
                self.deselect(button: tab)
                
                tabsStackView.addArrangedSubview(tab)
            }
        }
        self.tabButtons = tabsStackView.subviews as! [UISegmentedTableViewTabView]
        
        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fill
        let scrollViewContainer = UIView()
        segmentsScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollViewContainer.addSubview(segmentsScrollView)
        headerStackView.addArrangedSubview(scrollViewContainer)
        headerStackView.addArrangedSubview(tabsStackView)
        
//        tabsStackView.heightAnchor.constraint(equalTo: segmentsScrollView.heightAnchor, multiplier: 1).isActive = true
        
        headerStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        superviewStackView.addArrangedSubview(headerStackView)
        
        //layout table
        tableView.dataSource = self.tableDataSource ?? self // allows the user to use either UITableViewDataSource or the limited supported methods in UISegmentedTableViewDataSource
        tableView.delegate = self.tableDelegate ?? self
        tableView.reloadData()
        
        superviewStackView.addArrangedSubview(tableView)
        
        superviewStackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(superviewStackView)
    }
    
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    private func initLayout() {
        
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
    
    @objc private func press(_ tabButton: UISegmentedTableViewTabView) {
        self.setSelected(source: .TabButtons, index: tabButton.tag)
        delegate?.segmentedTableView?(self, didSelectAt: self.selectedIndex!)
        reloadTableView()
    }
    
    // MARK: - LIFE CYCLE

}

extension UISegmentedTableView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.segmentedTableView?(self, numberOfSectionsIn: tableView) ?? 0
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

extension UIRectCorner {
    init(topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool) {
        self.init()
        
        if topLeft {
            self.insert(.topLeft)
        }
        if topRight {
            self.insert(.topRight)
        }
        if bottomLeft {
            self.insert(.bottomLeft)
        }
        if bottomRight {
            self.insert(.bottomRight)
        }
    }
}

