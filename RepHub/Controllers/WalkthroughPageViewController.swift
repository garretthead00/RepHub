//
//  WalkthroughPageViewController.swift
//  RepHub
//
//  Created by Garrett Head on 7/9/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageContent = ["1","2","3"]
    var pageImage = ["ChargeIcon","PlannerIcon","LockerIcon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let startingVC = viewControllerAtIndex(index: 0) {
            setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughViewController).index
        index -= 1
        return viewControllerAtIndex(index:index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughViewController).index
        index += 1
        return viewControllerAtIndex(index:index)
    }
    
    private func viewControllerAtIndex(index: Int) -> WalkthroughViewController? {
        if index < 0 || index >= pageContent.count {
            return nil
        }
        if let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
        pageContentVC.content = pageContent[index]
        pageContentVC.index = index
        pageContentVC.imageFileName = pageImage[index]
            return pageContentVC
        }
        return nil
        
    }

    func next(index: Int) {
        if let nextVC = viewControllerAtIndex(index: index + 1) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    func prev(index: Int) {
        if let prevVC = viewControllerAtIndex(index: index - 1) {
            setViewControllers([prevVC], direction: .reverse, animated: true, completion: nil)
        }
    }

}
