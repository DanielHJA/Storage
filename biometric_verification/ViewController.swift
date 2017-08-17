//
//  ViewController.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 11/10/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, clearTableViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    let authenticationManager = BioMetricAccessManager()
    var passwordArray:[Passwords] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        authenticate()

    }
    
    func appMovedToBackground(){
        
        clearTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false
        
        let controller =  self.tabBarController?.customizableViewControllers?[1].childViewControllers[0] as! AddNewPasswordControllerViewController
        controller.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.authenticate), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func clearTableView() {
       
        passwordArray = []
        self.tableView.reloadData()
    }
    
    func authenticate(){
    
        authenticationManager.askUserForBiometricVerification(viewController: self) { (status, error) in

            guard status == .success else {

                DispatchQueue.main.async {
              
                AlertManager.alertWithAction(title: "Oops!", msg: "There was an error with the verification", viewController: self, hasCancelOption: false, completion: { (action) in
           
                    guard action == .ok else {
                        return
                    }
                    
                    self.authenticate()
                    
                    
                        })
                    }
                return
            }
            self.loadStoredPasswordsFromCoredata()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PasswordTableViewCell
        
        let entry = self.passwordArray[indexPath.row]
        
        cell.iconImageView.image = UIImage(data: entry.icon! as Data)
        cell.identifierLabel.text = entry.identifier
        cell.usernameLabel.text = entry.username
        cell.passwordLabel.text = entry.password
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            self.userDidRequestDeleteEntry(indexPath: indexPath)
        }
 
        delete.backgroundColor = UIColor.flatRed()
        
        let copy = UITableViewRowAction(style: .normal, title: "Copy") { (action, index) in
            self.copyPassword(indexPath: indexPath)
        }
        
        copy.backgroundColor = UIColor.flatGreen()
        
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, index) in
            self.userDidRequestUpdate(indexPath: indexPath)
        }
        
        update.backgroundColor = UIColor.flatBlue()
    
        return [copy, update, delete]
    }
    
    func userDidRequestDeleteEntry(indexPath: IndexPath){
    
        AlertManager.alertWithAction(title: "Delete Entry", msg: "Do you wish to remove this password?", viewController: self, hasCancelOption: true, completion: { (selection) in
            
            guard selection == .ok else {
                return
            }
            self.userDidRemoveEntry(indexPath)
        })
    }
    
    func userDidRequestUpdate(indexPath: IndexPath){
        
        let controller =  self.tabBarController?.customizableViewControllers?[1].childViewControllers[0] as! AddNewPasswordControllerViewController
        controller.passwordToUpdate = passwordArray[indexPath.row]
    
        passwordArray = []
        tableView.reloadData()
        
        self.tabBarController?.selectedIndex += 1
    }
    
    func copyPassword(indexPath: IndexPath){
    
        UIPasteboard.general.string = self.passwordArray[indexPath.row].password
        AlertManager.simpleAlert(msg: "Password copied to clipboard", error: nil, viewController: self)
        self.tableView.setEditing(false, animated: true)
    }
    
    func loadStoredPasswordsFromCoredata(){
        
        DispatchQueue.global().async {
        
        CoredataManager.userDidRequestFromEntity { (result, error) in
            
            guard error == nil else {
                
                DispatchQueue.main.async {
                    AlertManager.simpleAlert(msg: "Oops!", error: "There was an error loading the data.", viewController: self)
                }
                return
            }
            
            self.passwordArray = result!
        
        }
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
            }
        }
    
    func userDidRemoveEntry(_ indexPath: IndexPath){
        
        CoredataManager.userDidRemoveFromEntity(viewController: self, entry: passwordArray[indexPath.row])
        self.passwordArray.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .left)
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
