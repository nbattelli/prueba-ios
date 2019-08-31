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
        tabBar?.delegate = self
        tabBar?.selectedItem = tabBar?.items.first
        tabBar?.backgroundColor = MDCPalette.grey.tint900
        tabBar?.selectedItemTintColor = .white
        tabBar?.unselectedItemTintColor = MDCPalette.grey.tint400
        tabBar?.inkColor = MDCPalette.blueGrey.tint100
    }

}
