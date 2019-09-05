//
//  CellTransition.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 03/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class CellTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.3
    var isPresenting : Bool
    var cellTransitionView : CellTransitionViewProtocol
    var detailTransitionView: DetailTransitionViewProtocol
    
    init(isPresenting : Bool,
         cellTransitionView : CellTransitionViewProtocol,
         detailTransitionView: DetailTransitionViewProtocol)
    {
        self.isPresenting = isPresenting
        self.cellTransitionView = cellTransitionView
        self.detailTransitionView = detailTransitionView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let originalView: UIView
        let detailView: UIView
        
        if isPresenting {
            container.addSubview(toView)
            originalView = fromView
            detailView = toView
            toView.frame = CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            toView.alpha = 0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
            originalView = toView
            detailView = fromView
            toView.alpha = 1
        }
        
        toView.layoutIfNeeded()
        
        let image = cellTransitionView.transitionImageView()
        let cellImageViewFrame = image.convert(image.bounds, to: originalView)
        let cellImage = cellTransitionView.transitionImageView().image
        
        let detailImage = detailTransitionView.transitionImageView()
        detailImage.image = cellImage
        detailImage.alpha = 0
        
        
        let transitionImageView: UIImageView
        if isPresenting {
            transitionImageView = UIImageView(frame: cellImageViewFrame)
        } else {
            transitionImageView = UIImageView(frame: detailImage.convert(detailImage.bounds, to: toView))
        }
        transitionImageView.image = cellImage
        
        container.addSubview(transitionImageView)
        container.layer.cornerRadius = 8
        
        UIView.animate(withDuration: duration, animations: {
            if self.isPresenting {
                transitionImageView.frame = detailImage.convert(detailImage.bounds, to: toView)
                detailView.frame = fromView.frame
                detailView.alpha = 1
            } else {
                transitionImageView.frame = cellImageViewFrame
                detailView.frame = CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
                detailView.alpha = 0
            }
            
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            detailImage.alpha = 1
        })
    }
    
    
    
    
}

