//
//  MiniTabBarItemView.swift
//  Pods
//
//  Created by Dylan Marriott on 12/01/17.
//
//

import Foundation
import UIKit

class MiniTabBarItemView: UIView {
    let item: MiniTabBarItem
    let titleLabel = UILabel()
    let iconView = UIImageView()
    
    private var selected = false
    private let defaultInactiveColor = UIColor(white: 0.6, alpha: 1.0)
    
    override var tintColor: UIColor! {
        didSet {
            if self.selected {
                self.iconView.tintColor = self.tintColor
                self.titleLabel.textColor = self.tintColor
            }
        }
    }
    
    public var inactiveColor: UIColor! {
        didSet {
            if !self.selected {
                self.iconView.tintColor = self.inactiveColor ?? defaultInactiveColor
                self.titleLabel.textColor = self.inactiveColor ?? defaultInactiveColor
            }
        }
    }
    
    private let defaultFont = UIFont.systemFont(ofSize: 12)
    var font: UIFont? {
        didSet {
            self.titleLabel.font = self.font ?? defaultFont
        }
    }
    
    init(_ item: MiniTabBarItem) {
        self.item = item
        super.init(frame: CGRect.zero)
        
        if let customView = self.item.customView {
            assert(self.item.title == nil && self.item.icon == nil, "Don't set title / icon when using a custom view")
            assert(customView.frame.width > 0 && customView.frame.height > 0, "Custom view must have a width & height > 0")
            self.addSubview(customView)
        } else {
            assert(self.item.title != nil && self.item.icon != nil, "Title / Icon not set")
            if let title = self.item.title {
                titleLabel.text = title
                titleLabel.font = self.defaultFont
                titleLabel.textColor = self.tintColor
                titleLabel.textAlignment = .center
                self.addSubview(titleLabel)
            }
            
            if let icon = self.item.icon {
                iconView.image = icon.withRenderingMode(.alwaysTemplate)
                self.addSubview(iconView)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let customView = self.item.customView {
            customView.center = CGPoint(x: self.frame.width / 2 + self.item.offset.horizontal,
                                        y: self.frame.height / 2 + self.item.offset.vertical)
        } else {
            titleLabel.frame = CGRect(x: 0, y: self.frame.size.height - 24, width: self.frame.width, height: 12)
            iconView.frame = CGRect(x: self.frame.width / 2 - 12, y: 8, width: 24, height: 24)
        }
    }
    
    func setSelected(_ selected: Bool, animated: Bool = true) {
        self.selected = selected
        self.iconView.tintColor = selected ? self.tintColor : self.inactiveColor
        self.titleLabel.textColor = selected ? self.tintColor : self.inactiveColor
    }
}
