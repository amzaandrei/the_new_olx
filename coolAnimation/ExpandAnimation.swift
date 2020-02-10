//
//  File.swift
//  coolAnimation
//
//  Created by Andrew on 6/26/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation
import UIKit

class ExpandAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    
    
    @objc static var animator = ExpandAnimation()
    
    
    enum ExpandTransitionMode: Int{
        case Present, Dismiss
    }
    
    @objc let presentDuration = 0.4
    @objc let dismissDuration = 0.4
    
    var openingFrame: CGRect?
    var transitionMode: ExpandTransitionMode = .Present
    
    @objc var topView: UIView!
    @objc var bottomView: UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        if transitionMode == .Present{
            return presentDuration
        }else{
            return dismissDuration
        }
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let fromViewFram = fromViewController.view.frame
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView = transitionContext.containerView
        
        
        if transitionMode == .Present{
            topView = fromViewController.view.resizableSnapshotView(from: fromViewFram, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: (openingFrame?.origin.y)!, left: 0, bottom: 0, right: 0))
            topView.frame = CGRect(x: 0, y: 0, width: fromViewFram.width, height: (openingFrame?.origin.y)!)
            
            containerView.addSubview(topView)
            
            
            bottomView = fromViewController.view.resizableSnapshotView(from: fromViewFram, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: fromViewFram.height - (openingFrame?.origin.y)! - (openingFrame?.height)!, right: 0))
            
            bottomView.frame = CGRect(x: 0, y: (openingFrame?.origin.y)! + (openingFrame?.height)!, width: fromViewFram.width, height: fromViewFram.height - (openingFrame?.origin.y)! - (openingFrame?.height)!)
            
            containerView.addSubview(bottomView)
            
            
            let snapshotView = toViewController.view.resizableSnapshotView(from: fromViewFram, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
            
            snapshotView?.frame = openingFrame!
            containerView.addSubview(snapshotView!)
            
            
            toViewController.view.alpha = 0
            containerView.addSubview(toViewController.view)
            
            
            
            UIView.animate(withDuration: presentDuration, animations: { 
                
                self.topView.frame = CGRect(x: 0, y: -self.topView.frame.height, width: self.topView.frame.width, height: self.topView.frame.height)
                
                self.bottomView.frame = CGRect(x: 0, y: fromViewFram.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                
                
                snapshotView?.frame = toViewController.view.frame
                toViewController.view.alpha = 1
            }, completion: { (finished) in
                
                snapshotView?.removeFromSuperview()
                
                transitionContext.completeTransition(finished)
                
            })
            
            
        }else{
            
            let snapshotView = toViewController.view.resizableSnapshotView(from: fromViewFram, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
            
            snapshotView?.frame = openingFrame!
            containerView.addSubview(snapshotView!)
            
            fromViewController.view.alpha = 0
            
            UIView.animate(withDuration: dismissDuration, animations: {
                
                
                self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewController.view.frame.height - self.bottomView.frame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                snapshotView?.frame = self.openingFrame!
            }, completion: { (finished) in
                
                transitionContext.completeTransition(finished)
            })
            
            
        }
        
        
    }
}



















