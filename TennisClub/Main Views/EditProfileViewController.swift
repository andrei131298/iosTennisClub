//
//  EditProfileViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/30/21.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    

    @IBAction func saveBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if textFieldsHaveText(){
            
            let withValues = [kFIRSTNAME: firstNameTextField.text!, kLASTNAME: lastNameTextField.text!, kFULLNAME: firstNameTextField.text! + " " + lastNameTextField.text!, kFULLADDRESS: addressTextField.text!]
            updateCurrentUserInFirebase(withValues: withValues){ (error) in
                if error == nil{
                    self.hud.textLabel.text = "Updated"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                else{
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        }
        else{
            self.hud.textLabel.text = "All fields are required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    private func loadUserInfo(){
        
        if User.currentUser() != nil{
            let currentUser = User.currentUser()!
            firstNameTextField.text = currentUser.firstName
            lastNameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
        }
    }
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    private func textFieldsHaveText() -> Bool{
        
        return (firstNameTextField.text != "" && lastNameTextField.text != "" && addressTextField.text != "")
    }
}
