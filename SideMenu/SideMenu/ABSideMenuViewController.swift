//
//  ABSideMenuViewController.swift
//  SideMenu
//
//  Created by Bhat, Adithya H on 9/18/16.
//  Copyright © 2016 AB. All rights reserved.
//

import UIKit

class ABSideMenuViewController: UIViewController {

    var transformApplied = false
    var toggleInAction = false
    
    var sideMenuViewController:UIViewController? {
        didSet {
            if let viewController = self.sideMenuViewController {
                if  let oldSideMenuViewController = oldValue {
                    self.removeChildVC(childViewController: oldSideMenuViewController)
                }
                self.addChildVC(childViewController: viewController, containerView: self.view)
                viewController.view.layer.zPosition = -1000
            }
        }
    }

    var contentViewController:UIViewController? {
        didSet {
            if let viewController = self.contentViewController {
                if  let oldContentMenuViewController = oldValue {
                    self.removeChildVC(childViewController: oldContentMenuViewController)
                }
                self.addChildVC(childViewController: viewController, containerView: self.view)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAnchorPoint(CGPoint(x: 1, y: 0.5), forView:(self.contentViewController?.view)!)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sideMenuViewController?.view.frame = self.view.frame
        contentViewController?.view.frame = self.view.frame
    }
    
    /**
     Toggles the content view between its position at the center and the state where it reveals the side menu view.
     */
    func toggleCenterContentView() {
        var transform:CATransform3D
        if self.toggleInAction == false , let centerContentView = self.contentViewController?.view {
            if transformApplied {
                transform = CATransform3DIdentity
                self.toggleInAction = true
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               options: .curveEaseInOut,
                               animations: {
                                centerContentView.layer.transform = transform
                    },
                               completion: { (success) in
                                self.transformApplied = false
                                self.toggleInAction = false
                })
            } else {
                transform = centerContentView.layer.transform
                transform.m34 = 1 / -500
                transform = CATransform3DRotate(transform, -CGFloat(M_PI / 6), 0.0, 1.0, 0.0)
                transform = CATransform3DTranslate(transform,
                                                   self.view.bounds.width / 4,
                                                   0.0,
                                                   -150.0)
                self.toggleInAction = true
                UIView.animate(withDuration: 1.0,
                               delay: 0.0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 1.0,
                               options: .curveEaseInOut,
                               animations: {
                                centerContentView.layer.transform = transform
                }) { (success) in
                    self.transformApplied = !self.transformApplied
                    self.toggleInAction = false
                }
                
            }
        }
    }
    
    //MARK: Private methods
    
    //Changing the AnchorPoint changes the position of the layer. This method preserves the position of the layer.
    private func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }

    private func addChildVC(childViewController: UIViewController!, containerView: UIView!) {
        childViewController.willMove(toParentViewController: self)
        self.addChildViewController(childViewController)
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
    
    private func removeChildVC(childViewController: UIViewController!) {
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
}
