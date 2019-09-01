//
//  UIColor+Palette.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 01/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

extension UIColor {
    private static let white00 = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)

    private static let blue900 = UIColor(red: 0.06, green: 0.13, blue: 0.15, alpha: 1.0)
    private static let blue800 = UIColor(red: 0.22, green: 0.28, blue: 0.31, alpha: 1.0)
    private static let blue400 = UIColor(red: 0.38, green: 0.45, blue: 0.48, alpha: 1.0)

    private static let orangeA900 = UIColor(red: 0.64, green: 0.00, blue: 0.00, alpha: 1.0)
    private static let orangeA700 = UIColor(red: 0.87, green: 0.17, blue: 0.00, alpha: 1.0)
    private static let orangeA500 = UIColor(red: 1.00, green: 0.39, blue: 0.20, alpha: 1.0)
    
    
    static let primaryColor = UIColor.blue800
    static let primaryLightColor = UIColor.blue400
    static let primaryDarkColor = UIColor.blue900
    static let primaryTextColor = UIColor.white00
    
    static let secondaryColor = UIColor.orangeA700
    static let secondaryLightColor = UIColor.orangeA500
    static let secondaryDarkColor = UIColor.orangeA900
    static let secondaryTextColor = UIColor.white00

}
