//
//  ContainerViewController.swift
//  RepHub
//
//  Created by Garrett on 1/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit


class ContainerViewController: UIViewController {
    
    enum SlideOutState {
        case bothCollapsed
        case rightPanelExpanded
    }
    
    var lockerNavigationController: UINavigationController!
    var lockerViewController: LockerViewController!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var lockerMenuViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockerViewController = UIStoryboard.lockerViewController()!
        lockerViewController.delegate = self
        lockerNavigationController = UINavigationController(rootViewController: lockerViewController)
        view.addSubview(lockerNavigationController.view)
        addChild(lockerNavigationController)
        lockerNavigationController.didMove(toParent: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        lockerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: CenterViewController delegate
extension ContainerViewController: CenterViewControllerDelegate {
    
    
    func toggleRightPanel() {
        print("toggleRightPanel from ContainerVC")
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        default:
            break
        }
    }

    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        sidePanelController.delegate = lockerViewController
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    func addRightPanelViewController() {
        
        guard lockerMenuViewController == nil else { return }
        if let vc = UIStoryboard.lockerMenuViewController() {
            //vc.animals = Animal.allDogs()
            addChildSidePanelController(vc)
            lockerMenuViewController = vc
        }
    }

    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.lockerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(targetPosition: -lockerNavigationController.view.frame.width + centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.lockerMenuViewController?.view.removeFromSuperview()
                self.lockerMenuViewController = nil
            }
        }
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            lockerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            lockerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let gestureIsDraggingFromRightToLeft = (recognizer.velocity(in: view).x < 0)
        
        switch recognizer.state {
            
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromRightToLeft {
                    addRightPanelViewController()
                }
                
                showShadowForCenterViewController(true)
            }
            
        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            if let _ = lockerMenuViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
    }
}

private extension UIStoryboard {
    
    static func main() -> UIStoryboard { return UIStoryboard(name: "Locker", bundle: Bundle.main) }
    
    static func lockerMenuViewController() -> SidePanelViewController? {
        return main().instantiateViewController(withIdentifier: "LockerMenuViewController") as? SidePanelViewController
    }
    
    static func lockerViewController() -> LockerViewController? {
        return main().instantiateViewController(withIdentifier: "LockerViewController") as? LockerViewController
    }
}
