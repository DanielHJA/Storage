//
//  ActivityIndicator.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 2016-10-22.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ActivityIndicator: NSObject {

    var indicator: UIActivityIndicatorView?
    
     func displayActivityIndicator(viewController: UIViewController){
    
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator!.transform = CGAffineTransform(scaleX: 1.8, y: 1.8);
        indicator!.center = viewController.view.center
        indicator!.startAnimating()
        viewController.view.addSubview(indicator!)
    }
}
