//
//  NavigationController.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 19/10/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit
import ChameleonFramework

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = UIBarStyle.default
        
        self.navigationBar.barTintColor = UIColor.flatGreen()

        self.navigationBar.tintColor = UIColor.white
        
        let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
        
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName:UIColor.white]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
