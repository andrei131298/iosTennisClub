//
//  FinishRegistrationViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/30/21.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    

    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        finishOnBoarding()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        updateDoneButtonStatus()
    }
    
    private func updateDoneButtonStatus(){
        
        if firstNameTextField.text != "" && lastNameTextField.text != "" && addressTextField.text != ""{
            doneButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            doneButton.isEnabled = true
        }
        else{
            doneButton.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            doneButton.isEnabled = false
        }
    }
    private func finishOnBoarding(){
        let withValues = [kFIRSTNAME: firstNameTextField.text!, kLASTNAME: lastNameTextField.text!, kONBOARD: true, kFULLADDRESS: addressTextField.text!, kFULLNAME: (firstNameTextField.text! + " " + lastNameTextField.text!)] as [String:Any]
        
        updateCurrentUserInFirebase(withValues: withValues) { (error) in
            if error == nil{
                self.hud.textLabel.text = "Updated"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.hud.textLabel.text = error?.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
}
