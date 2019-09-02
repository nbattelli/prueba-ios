//
//  TabBarController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import MaterialComponents.MDCTabBarViewController

class TabBarController: MDCTabBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTabBar()
    }
    
    func loadTabBar() {
        self.tabBar?.delegate = self
        self.tabBar?.selectedItem = tabBar?.items.first
        self.tabBar?.backgroundColor = UIColor.primaryColor
        self.tabBar?.selectedItemTintColor = UIColor.secondaryLightColor
        self.tabBar?.unselectedItemTintColor = UIColor.primaryTextColor
        self.tabBar?.inkColor = UIColor.secondaryLightColor.withAlphaComponent(0.2)
    }

}
