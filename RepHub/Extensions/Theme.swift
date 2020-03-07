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
        //$seam-foam:  rgb(3, 249, 135);
        static var seaFoam: UIColor  { return UIColor(red: 3.0/255.0, green: 249.0/255.0, blue: 135.0/255.0, alpha: 1.0) }
        //$tangerine:  rgb(255, 136, 2);
        static var tangarine: UIColor { return UIColor(red: 255.0/255.0, green: 136.0/255.0, blue: 2.0, alpha: 1.0) }
        //$banana:     rgb(255, 251, 109);
        static var banana: UIColor { return UIColor(red: 255.0/255.0, green: 251.0/255.0, blue: 109.0/255.0, alpha: 1.0) }
        //$cayenne:    rgb(137, 17, 0);
        static var cayenne: UIColor { return UIColor(red: 137.0/255.0, green: 17.0/255.0, blue: 0.0/255.0, alpha: 1.0) }
        //$maraschino: rgb(255, 33, 1);
        static var maraschino: UIColor { return UIColor(red: 255.0/255.0, green: 33.0/255.0, blue: 1.0/255.0, alpha: 1.0) }
        //$salmon:     rgb(255, 114, 110);
        static var salmon: UIColor { return UIColor(red: 255.0/255.0, green: 114.0/255.0, blue: 110.0/255.0, alpha: 1.0) }
        //$sky:        rgb(106, 207, 255);
        static var sky: UIColor { return UIColor(red: 106.0/255.0, green: 207.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
        //$aqua:       rgb(0, 140, 255);
        static var aqua: UIColor { return UIColor(red: 0.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
        //$lavender:   rgb(210, 120, 255);
        static var lavender: UIColor { return UIColor(red: 210.0/255.0, green: 120.0/255.0, blue: 255.0/255.0, alpha: 1.0) }
        //$honeydew:   rgb(206, 250, 110);
        static var honeydew: UIColor { return UIColor(red: 206.0/255.0, green: 250.0/255.0, blue: 110.0/255.0, alpha: 1.0) }
        //$flora:      rgb(104, 249, 110);
        static var flora: UIColor { return UIColor(red: 104.0/255.0, green: 249.0/255.0, blue: 110.0/255.0, alpha: 1.0) }
        //$spring:     rgb(5, 248, 2);
        static var spring: UIColor { return UIColor(red: 5.0/255.0, green: 248.0/255.0, blue: 2.0/255.0, alpha: 1.0) }

    }
    

}

extension UIImage {
    struct Theme {

    }
}




//  MARK: - Activity Theme
extension UIColor.Theme {
    struct Activity {
        static var mind : UIColor { return UIColor.Theme.lavender }
        static var exercise: UIColor { return UIColor.Theme.maraschino }
        static var eat: UIColor  { return UIColor.Theme.spring }
        static var hydrate: UIColor { return UIColor.Theme.aqua }
    }
}



extension UIImage.Theme {
    struct Activity {
        static var mind : UIImage { return UIImage(named: "Mind")!.withRenderingMode(.alwaysOriginal)}
        static var exercise : UIImage { return UIImage(named: "exerciseActivity")!.withRenderingMode(.alwaysOriginal)}
        static var eat : UIImage { return UIImage(named: "eatActivity")!.withRenderingMode(.alwaysOriginal)}
        static var hydrate : UIImage { return UIImage(named: "hydrateActivity")!.withRenderingMode(.alwaysOriginal)}
    }
}


//$cantaloupe: rgb(255, 206, 110);
//$honeydew:   rgb(206, 250, 110);
//$spindrift:  rgb(104, 251, 208);
//$sky:        rgb(106, 207, 255);
//$lavender:   rgb(210, 120, 255);
//$carnation:  rgb(255, 127, 211);
//$licorice:   rgb(0, 0, 0);
//$snow:       rgb(255, 255, 255);
//$salmon:     rgb(255, 114, 110);
//$banana:     rgb(255, 251, 109);
//$flora:      rgb(104, 249, 110);
//$ice:        rgb(104, 253, 255);
//$orchid:     rgb(110, 118, 255);
//$bubblegum:  rgb(255, 122, 255);
//$lead:       rgb(30, 30, 30);
//$mercury:    rgb(232, 232, 232);
//$tangerine:  rgb(255, 136, 2);
//$lime:       rgb(131, 249, 2);
//$seam-foam:  rgb(3, 249, 135);
//$aqua:       rgb(0, 140, 255);
//$grape:      rgb(137, 49, 255);
//$strawberry: rgb(255, 41, 135);
//$tungsten:   rgb(58, 58, 58);
//$silver:     rgb(208, 208, 208);
//$maraschino: rgb(255, 33, 1);
//$lemon:      rgb(255, 250, 3);
//$spring:     rgb(5, 248, 2);
//$turquoise:  rgb(0, 253, 255);
//$blueberry:  rgb(0, 46, 255);
//$magenta:    rgb(255, 57, 255);
//$iron:       rgb(84, 84, 83);
//$magnesium:  rgb(184, 184, 184);
//$mocha:      rgb(137, 72, 0);
//$fern:       rgb(69, 132, 1);
//$moss:       rgb(1, 132, 72);
//$ocean:      rgb(0, 74, 136);
//$eggplant:   rgb(73, 26, 136);
//$maroon:     rgb(137, 22, 72);
//$steel:      rgb(110, 110, 110);
//$aluminum:   rgb(160, 159, 160);
//$cayenne:    rgb(137, 17, 0);
//$aspargus:   rgb(136, 133, 1);
//$clover:     rgb(2, 132, 1);
//$teal:       rgb(0, 134, 136);
//$midnight:   rgb(0, 24, 136);
//$plum:       rgb(137, 30, 136);
//$tin:        rgb(135, 134, 135);
//$nickel:     rgb(136, 135, 135);
