//
//  MiniTabBar.swift
//  Pods
//
//  Created by Dylan Marriott on 11/01/17.
//
//

import Foundation
import UIKit

@objc public class MiniTabBarItem: NSObject {
    var title: String?
    var icon: UIImage?
    var customView: UIView?
    var offset = UIOffset.zero
    public var selectable: Bool = true
    public init(title: String, icon:UIImage) {
        self.title = title
        self.icon = icon
    }
    public init(customView: UIView, offset: UIOffset = UIOffset.zero) {
        self.customView = customView
        self.offset = offset
    }
}

@objc public protocol MiniTabBarDelegate: class {
    func onTabSelected(_ index: Int)
}

@objc public class MiniTabBar: UIView {
    
    public weak var delegate: MiniTabBarDelegate?
    public let keyLine = UIView()

    public override var tintColor: UIColor! {
        didSet {
            for (index, v) in self.itemViews.enumerated() {
                v.setSelected((index == self.currentSelectedIndex), animated: true)
            }
        }
    }
    
    public var inactiveColor: UIColor! {
        didSet {
            for (index, v) in self.itemViews.enumerated() {
                v.setSelected((index == self.currentSelectedIndex), animated: true)
            }
        }
    }

    
    public var font: UIFont? {
        didSet {
            for itv in self.itemViews {
                itv.font = self.font
            }
        }
    }
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight)) as UIVisualEffectView
    public var backgroundBlurEnabled: Bool = true {
        didSet {
            self.visualEffectView.isHidden = !self.backgroundBlurEnabled
        }
    }
    
    fileprivate var itemViews = [MiniTabBarItemView]()
    fileprivate var currentSelectedIndex: Int?
    
    public init(items: [MiniTabBarItem]) {
        super.init(frame: CGRect.zero)
        
        //self.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        
        self.addSubview(visualEffectView)
        
        keyLine.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.addSubview(keyLine)
        
        self.initTabs(items)
    }
    
    public func setTabs(_ tabs: [MiniTabBarItem]) {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        self.addSubview(visualEffectView)
        
        self.itemViews = [MiniTabBarItemView]()
        
        self.addSubview(keyLine)
        
        self.initTabs(tabs)
    }
    
    private func initTabs(_ tabs: [MiniTabBarItem]) {
        var i = 0
        for tab in tabs {
            let tabView = MiniTabBarItemView(tab, self)
            tabView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MiniTabBar.itemTapped(_:))))
            self.itemViews.append(tabView)
            self.addSubview(tabView)
            i += 1
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        visualEffectView.frame = self.bounds
        keyLine.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        
        let itemWidth = self.frame.width / CGFloat(self.itemViews.count)
        for (i, itemView) in self.itemViews.enumerated() {
            let x = itemWidth * CGFloat(i)
            itemView.frame = CGRect(x: x, y: 0, width: itemWidth, height: frame.size.height)
        }
    }
    
    @objc func itemTapped(_ gesture: UITapGestureRecognizer) {
        let itemView = gesture.view as! MiniTabBarItemView
        let selectedIndex = self.itemViews.index(of: itemView)!
        self.selectItem(selectedIndex, animated: true);
    }
    
    @objc public func selectItem(_ selectedIndex: Int, animated: Bool = true) {
        if (selectedIndex == self.currentSelectedIndex) {
            return
        }
        
        self.delegate?.onTabSelected(selectedIndex)

        if !self.itemViews[selectedIndex].item.selectable {
            return
        }
        
        for (index, v) in self.itemViews.enumerated() {
            v.setSelected((index == selectedIndex), animated: animated)
        }
        
        self.currentSelectedIndex = selectedIndex
    }
}

