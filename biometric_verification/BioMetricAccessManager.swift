//
//  BioMetricAccessController.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 19/10/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit
import LocalAuthentication

enum Status {
    case success
    case failure
}

class BioMetricAccessManager: NSObject {

    var isAuthenticating: Bool = false
    
     func askUserForBiometricVerification(viewController: UIViewController, completion: @escaping (_ status: Status, _ error: NSError?)->()){
    
        isAuthenticating = true
        
        let authenticationContext = LAContext()
        
        var error: NSError? = nil
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            AlertManager.simpleAlert(msg: "TouchID not available", error: nil, viewController: viewController)
            return
        }
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please authenticate yourself") { (success, err) in
            
            if success {
                
                completion(.success, nil)
                
            } else {
                
                if err != nil {
                    
                completion(.failure, err as NSError?)
                    
                }
            }
        }
    
        isAuthenticating = false
    }
}
