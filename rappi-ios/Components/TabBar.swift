//
//  TabBar.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import MaterialComponents.MaterialTabs

final class TabBar: MDCTabBar {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    init(frame: CGRect, delegate: MDCTabBarDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        self.tintColor = UIColor.secondaryLightColor
        self.barTintColor = UIColor.primaryColor
        self.inkColor = UIColor.secondaryLightColor.withAlphaComponent(0.2)
        self.alignment = .justified
        self.itemAppearance = .titles
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sizeToFit()
    }
    
}
