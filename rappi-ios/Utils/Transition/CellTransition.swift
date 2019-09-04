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
        
        self.isPresenting ? container.addSubview(toView) : container.insertSubview(toView, belowSubview: fromView)
        
        let originalView = isPresenting ? fromView : toView
        let detailView = isPresenting ? toView : fromView
        
        let image = cellTransitionView.transitionImageView()
        let cellImageViewFrame = image.convert(image.frame, to: originalView)
        let cellImage = cellTransitionView.transitionImageView().image
        
        let detailImage = detailTransitionView.transitionImageView()
        detailImage.image = cellImage
        detailImage.alpha = 0
        
        let transitionImageView = UIImageView(frame: isPresenting ? cellImageViewFrame : detailImage.frame)
        transitionImageView.image = cellImage
        
        container.addSubview(transitionImageView)
        
        toView.frame = isPresenting ?  CGRect(x: fromView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height) : toView.frame
        toView.alpha = isPresenting ? 0 : 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            transitionImageView.frame = self.isPresenting ? detailImage.frame : cellImageViewFrame
            detailView.frame = self.isPresenting ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
            detailView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            transitionImageView.removeFromSuperview()
            detailImage.alpha = 1
        })
    }
    
    
    
    
}

