//
//  UIImageView+URL.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func load(url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        
        self.sd_setImage(with: imageURL)
    }
    
    func cancelLoadImage() {
        self.sd_cancelCurrentImageLoad()
    }
    
    public func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
}

