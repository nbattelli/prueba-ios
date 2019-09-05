//
//  UIView+Loading.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 05/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import MaterialComponents.MDCActivityIndicator

extension UIView {
    private struct AssociatedKeys {
        static var loadingView: UIView?
    }
    
    private var loadingView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingView) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showAsLoading() {
        guard self.loadingView == nil else {return}
        
        let view = UIView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.alpha = 0.5
        view.backgroundColor = UIColor.primaryDarkColor
        
        let activityIndicator = MDCActivityIndicator()
        
        activityIndicator.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        view.addSubview(activityIndicator)
        activityIndicator.sizeToFit()
        activityIndicator.center = view.center
        
        activityIndicator.startAnimating()
        
        self.addSubview(view)
    }
    
    func stopLoading() {
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
    }
}
