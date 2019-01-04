//
//  MainTBC.swift
//  RepHub
//
//  Created by Garrett Head on 3/21/18.
//  Copyright © 2018 Garrett Head. All rights reserved.
//

import UIKit

class MainTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        let selectedVC = tabBarController.selectedViewController
        let navigation = selectedVC as! UINavigationController
        navigation.popToRootViewController(animated: false)
        print("Tabbar didSelectViewController called.")
        // rest of the logic
    }

}
