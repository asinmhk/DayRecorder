//
//  TaskViewControllerDelegate.swift
//  Note
//
//  Created by apple on 2017/12/23.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

@objc
protocol TaskViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    //@objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
}

