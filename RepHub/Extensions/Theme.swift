//
//  Theme.swift
//  RepHub
//
//  Created by Garrett Head on 5/28/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation


// MARK: - Global Theme
extension UIColor {
    struct Theme {
        //rgb(255, 114, 110);
        static var seaFoam: UIColor  { return UIColor(red: 0.0, green: 250.0/255.0, blue: 146.0/255.0, alpha: 1.0) }
        static var tangarine: UIColor { return UIColor(red: 1.0/255.0, green: 147.0/255.0, blue: 0.0, alpha: 1.0) }
        static var banana: UIColor { return UIColor(red: 1.0/255.0, green: 252.0/255.0, blue: 121.0/255.0, alpha: 1.0) }
        static var salmon: UIColor { return UIColor(red: 255.0/255.0, green: 114.0/255.0, blue: 110.0/255.0, alpha: 1.0) }
        static var sky: UIColor { return UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
        static var aqua: UIColor { return UIColor(red: 0.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
        static var lavender: UIColor { return UIColor(red: 215.0/255.0, green: 131.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
    }
    

}

extension UIImage {
    struct Theme {

    }
}




//  MARK: - Activity Theme
extension UIColor.Theme {
    struct Activity {
        static var mind : UIColor { return UIColor(red: 215.0/255.0, green: 131.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
        static var exercise: UIColor { return UIColor(red: 255.0/255.0, green: 114.0/255.0, blue: 110.0/255.0, alpha: 1.0) }
        static var eat: UIColor  { return UIColor(red: 0.0, green: 250.0/255.0, blue: 146.0/255.0, alpha: 1.0) }
        static var hydrate: UIColor { return UIColor(red: 0.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
    }
}



extension UIImage.Theme {
    struct Activity {
        static var mind : UIImage { return UIImage(named: ActivityName.mind.rawValue)!}
        static var exercise : UIImage { return UIImage(named: ActivityName.exercise.rawValue)!}
        static var eat : UIImage { return UIImage(named: ActivityName.eat.rawValue)!}
        static var hydrate : UIImage { return UIImage(named: ActivityName.hydrate.rawValue)!}
    }
}
