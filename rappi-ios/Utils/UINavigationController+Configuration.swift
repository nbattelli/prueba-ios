//
//  UINavigationController+Configuration.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 01/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

extension UINavigationController {
    static func configureNavigationApp() {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.primaryDarkColor
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
