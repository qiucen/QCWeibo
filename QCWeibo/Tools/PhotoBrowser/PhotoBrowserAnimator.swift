//
//  PhotoBrowserAnimator.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import UIKit

// MARK: - present delegate
protocol PhotoBrowserPresentDelegate: NSObject {
    
    /// `transition for specified image view`
    func imageViewToPresent(indexPath: IndexPath) -> UIImageView
    /// `from rect`
    func photoBrowserPresentFromRect(indexPath: IndexPath) -> CGRect
    /// `to rect`
    func photoBrowserPresentToRect(indexPath: IndexPath) -> CGRect
    
}

// MARK: - dismiss delegate
protocol PhotoBrowserDismissDelegate: NSObject {
    
    /// `image view`
    func imageViewToDismiss() -> UIImageView
    /// `index path`
    func indexPathToDismiss() -> IndexPath
}


/// `animator`
class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {

    weak var presentDelegate: PhotoBrowserPresentDelegate?
    weak var dismissDelegate: PhotoBrowserDismissDelegate?
    
    var indexPath: IndexPath?
    private var isPresented = false
    
    func setDelegateParams(
        presentDelegate: PhotoBrowserPresentDelegate,
        indexPath: IndexPath,
        dismissDelegate: PhotoBrowserDismissDelegate
    ) {
        self.presentDelegate = presentDelegate
        self.indexPath = indexPath
        self.dismissDelegate = dismissDelegate
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


// MARK: - implementation
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentAnimation(using: transitionContext) : dismissAnimation(using: transitionContext)
        
    }
    
    /// `present animation`
    private func presentAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentDelegate = presentDelegate, let indexPath = indexPath else { return }
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        transitionContext.containerView.addSubview(toView)
        
        let toVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to
        ) as! PhotoBrowserViewController
        
        toVC.collectionView.isHidden = true
        
        let imageView = presentDelegate.imageViewToPresent(indexPath: indexPath)
        imageView.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        
        transitionContext.containerView.addSubview(imageView)
        toView.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentDelegate.photoBrowserPresentToRect(indexPath: indexPath)
            toView.alpha = 1
        }) { (_) in
            imageView.removeFromSuperview()
            toVC.collectionView.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
    
    /// `dismiss animation`
    private func dismissAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentDelegate = presentDelegate, let dismissDelegate = dismissDelegate else { return }
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        fromView?.removeFromSuperview()
        
        let imageView = dismissDelegate.imageViewToDismiss()
        transitionContext.containerView.addSubview(imageView)
        
        let indexPath = dismissDelegate.indexPathToDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
    
    
}
