//
//  MDCTabBar+Util.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import MaterialComponents.MaterialTabs

extension MDCTabBar {

    static func buildCustomTabBar(frame: CGRect, delegate: MDCTabBarDelegate) -> MDCTabBar {
        let tabBar = MDCTabBar(frame: frame)
        tabBar.delegate = delegate
        tabBar.tintColor = MDCPalette.grey.tint400
        tabBar.barTintColor = MDCPalette.grey.tint900
        tabBar.alignment = .justified
        tabBar.itemAppearance = .titles
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tabBar.displaysUppercaseTitles = true
        tabBar.sizeToFit()
        return tabBar
    }

}
