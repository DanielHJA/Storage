//
//  AlertManager.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 19/10/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum ActionSelection {
    case ok
    case cancel
}

class AlertManager: NSObject {

   class func simpleAlert(msg: String, error: String?, viewController: UIViewController) {
        
        let alert = UIAlertController(title: msg, message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
   class func alertWithAction(title: String, msg: String, viewController: UIViewController, hasCancelOption: Bool, completion: @escaping (_ action: ActionSelection)->()) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (selection) in
            
            completion(.ok)
        }
       
        alertController.addAction(defaultAction)
        
        if hasCancelOption {
        
        let cancelAction = UIAlertAction(title: "No Thanks", style: .cancel) { (selection) in
            
            completion(.cancel)
        }
        
        alertController.addAction(cancelAction)
        
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func alertWithActionBlockreturn(title: String, msg: String, viewController: UIViewController,success: @escaping (((UIAlertAction) -> Void)), cancel: @escaping (((UIAlertAction) -> Void))) {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { (Approved) in

            success(Approved)
            
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (Canceled) in

            cancel(Canceled)
            
        })
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
