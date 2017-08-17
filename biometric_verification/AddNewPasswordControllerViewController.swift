//
//  AddNewPasswordControllerViewController.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 19/10/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.

protocol clearTableViewProtocol {
    func clearTableView()
}

import UIKit

class AddNewPasswordControllerViewController: UIViewController, SelectedIconProtocol, UITextFieldDelegate, UITabBarControllerDelegate {

    @IBOutlet weak var identifierTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var storePasswordButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var passwordToUpdate: Passwords?
    var delegate: clearTableViewProtocol?
    var isUpdating = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard passwordToUpdate != nil else {
            return
        }
    
        if !isUpdating {
        
        self.storePasswordButton.setTitle("Update Entry", for: .normal)
        self.identifierTextfield.text = passwordToUpdate?.identifier
        self.usernameTextfield.text = passwordToUpdate?.username
        self.passwordTextfield.text = passwordToUpdate?.password
        
        if let passwordToUpd = passwordToUpdate?.icon {
        
            self.iconImageView.image = UIImage(data: passwordToUpd as Data)
            
        }
            
        self.isUpdating = true
            
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        identifierTextfield.delegate = self
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        self.tabBarController?.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
        self.storePasswordButton.setTitle("Store Entry", for: .normal)
        passwordToUpdate = nil
        clearAllEntryFields()
        delegate?.clearTableView()
    }
    
    @IBAction func userDidSavePassword(_ sender: UIButton) {
        
        guard let identifier = identifierTextfield.text , !identifier.isEmpty else {
            alertError(message: "An identifier is required in order to store an entry", error: nil)
            return
        }
        
        guard let username = usernameTextfield.text, !username.isEmpty else {
            alertError(message: "A username is required in order to store an entry.", error: nil)
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            alertError(message: "A password is required in order to store an entry.", error: nil)
            return
        }
        
        guard let icon = iconImageView.image else {
            alertError(message: "Please select an icon.", error: nil)
            return
        }
        
        let iconData: NSData = UIImagePNGRepresentation(icon)! as NSData

        guard passwordToUpdate == nil else {
            CoredataManager.userDidUpdateExistingPassword(viewController: self, entry: self.passwordToUpdate!, identifier: identifier, username: username, password: password, icon: iconData)
            
            self.clearAllEntryFields()
            self.tabBarController?.selectedIndex -= 1

            return
        }
        
        CoredataManager.userDidAddToEntity(viewController: self, identifier: identifier, username: username, password: password, icon: iconData)
        
        AlertManager.alertWithAction(title: "", msg: "Would you like to add another entry?", viewController: self, hasCancelOption: true) { (action) in
            
            guard action == .ok else {
                self.tabBarController?.selectedIndex -= 1
                return
            }
            self.clearAllEntryFields()
        }
    }
    
    @IBAction func userDidSelectIcon(_ sender: UIButton) {

        performSegue(withIdentifier: "SelectIconSegue", sender: nil)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "SelectIconSegue" {
    
            let vc = segue.destination as! IconsCollectionViewController
            vc.delegate = self
        }
    }

    func didSelectIcon(icon: Data) {
        
        self.iconImageView.image = UIImage(data: icon)
    }
    
    func clearAllEntryFields(){
    
        self.identifierTextfield.text = ""
        self.usernameTextfield.text = ""
        self.passwordTextfield.text = ""
        self.iconImageView.image = nil
        self.isUpdating = false
    }
    
    func alertError(message: String, error: NSError?){
         AlertManager.simpleAlert(msg: message, error: error?.localizedDescription, viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
