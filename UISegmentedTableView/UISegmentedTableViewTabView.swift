//
//  UISegmentedTableViewTab.swift
//  temp
//
//  Created by Erick Sanchez on 5/6/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit

@IBDesignable
open class UISegmentedTableViewTabView: UIButton {
    
    private lazy var outlineLayer: CAShapeLayer = {
        let outlineLayer = CAShapeLayer()
        layer.insertSublayer(outlineLayer, at: 0)
        
        return outlineLayer
    }()
    
    @IBInspectable
    public var outlineColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var badgeTextLayer: CATextLayer = {
        let badgeTextLayer = CATextLayer()
        layer.addSublayer(badgeTextLayer)
        
        return badgeTextLayer
    }()
    
    @IBInspectable
    public var badgeText: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var badgeFont: UIFont = UIFont.systemFont(ofSize: 10.0)
    
    private lazy var badgeBackgroundLayer: CAShapeLayer = {
        let badgeBackgroundLayer = CAShapeLayer()
        layer.insertSublayer(badgeBackgroundLayer, below: badgeTextLayer)
        
        return badgeBackgroundLayer
    }()
    
    @IBInspectable
    public var badgeBackgroundColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override var backgroundColor: UIColor? {
        set {
            outlineLayer.fillColor = newValue?.cgColor
        }
        get {
            if let color = outlineLayer.fillColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    // MARK: - RETURN VALUES
    
    public convenience init(title: String?, tintColor: UIColor) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.tintColor = tintColor
        self.outlineColor = tintColor
        self.badgeBackgroundColor = tintColor
        
        configure()
    }
    
    public convenience init(icon: UIImage?, tintColor: UIColor) {
        self.init(type: .system)
        
        self.imageView?.contentMode = .center
        //TODO: constraint icons to be only squares
        self.setImage(icon, for: .normal)
        self.tintColor = tintColor
        self.outlineColor = tintColor
        self.badgeBackgroundColor = tintColor
        
        configure()
    }
    
    // MARK: - VOID METHODS
    
    private func configure() {
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 4.0, bottom: 4.0, right: 4.0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        //outline rect
        let radius = 4.0
        let outlinePath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        outlineLayer.path = outlinePath.cgPath
        outlineLayer.frame = bounds
        outlineLayer.strokeColor = outlineColor?.cgColor
        outlineLayer.lineWidth = 1.0
        
        //Badge text
        if let badgeText = self.badgeText {
            let attributes: [NSAttributedStringKey: Any] = [.font: self.badgeFont]
            let attributedString = NSMutableAttributedString(
                string: badgeText,
                attributes: attributes
            )
            let textSize = (badgeText as NSString).size(withAttributes: attributes)
            var nLines = 0
            (badgeText as NSString).enumerateLines { _,_ in nLines += 1 }
            
            badgeTextLayer.string = attributedString
            badgeTextLayer.frame = CGRect(
                x: bounds.width - textSize.width,
                y: -textSize.height + 2.0,
                width: textSize.width,
                height: textSize.height
            )
            badgeTextLayer.foregroundColor = UIColor.green.cgColor
            
            //Rounded Rect behind the text
            let textBadgeCornerRadius = textSize.height / 2.0 / CGFloat(nLines)
            let roundedRectPath = UIBezierPath(
                roundedRect: badgeTextLayer.frame.insetBy(dx: -textBadgeCornerRadius * 0.75, dy: -2),
                cornerRadius: textBadgeCornerRadius
            )
            badgeBackgroundLayer.path = roundedRectPath.cgPath
            badgeBackgroundLayer.fillColor = badgeBackgroundColor?.cgColor
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
}
