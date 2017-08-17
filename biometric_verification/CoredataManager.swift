//
//  CoredataManager.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 19/10/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//
import UIKit
import CoreData

class CoredataManager: NSObject {
        
   class func userDidAddToEntity(viewController: UIViewController, identifier: String, username: String, password: String, icon: NSData){
    
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Passwords", in: context!)
        let entry = NSManagedObject(entity: entity!, insertInto: context!) as! Passwords
        
        entry.identifier = identifier
        entry.username = username
        entry.password = password
        entry.icon = icon
        
        do {
        
            try context?.save()
        
        } catch let error as NSError {
        
            AlertManager.simpleAlert(msg: "Error", error: error.localizedDescription, viewController: viewController)
        }
    }
    
    class func userDidRemoveFromEntity(viewController: UIViewController, entry: Passwords){
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        context?.delete(entry)
        
        do {
            
            try context?.save()
            
        } catch let error as NSError {
            
            AlertManager.simpleAlert(msg: "Error", error: error.localizedDescription, viewController: viewController)
        }
    }
    
    class func userDidRequestFromEntity(completion: @escaping (_ results:[Passwords]?, _ error: NSError?)->()) {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let request: NSFetchRequest<Passwords> = Passwords.fetchRequest()
        
        do {
        
            let searchResults = try context?.fetch(request)
            completion(searchResults!, nil)
            
        } catch let error as NSError {
           
            print(error.localizedDescription)
            completion(nil, error)
        
        }
    }
    
    class func userDidUpdateExistingPassword(viewController: UIViewController, entry: Passwords, identifier: String, username: String, password: String, icon: NSData){
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
        entry.identifier = identifier
        entry.username = username
        entry.password = password
        entry.icon = icon
        
        do {
            
            try context?.save()
            
        } catch let error as NSError {
            
            AlertManager.simpleAlert(msg: "Error", error: error.localizedDescription, viewController: viewController)
        }
    }
}
