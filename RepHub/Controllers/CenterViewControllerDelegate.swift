//
//  CenterViewControllerDelegate.swift
//  RepHub
//
//  Created by Garrett on 1/7/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import Foundation

@objc
protocol CenterViewControllerDelegate {
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}
