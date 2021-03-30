//
//  WelcomeViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/30/21.
//

import UIKit
import  JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator : NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), padding: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if textFieldsHaveText(){
            
            loginUser()
            
        }
        else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if textFieldsHaveText(){
            
            //register user
            registerUser()
            
        }
        else{
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        if emailTextField.text != ""{
            resetThePassword()
        }
        else{
            hud.textLabel.text = "Please insert email"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        
        User.resendVerificationEmail(email: emailTextField.text!) { (error) in
            print("error resending email", error?.localizedDescription)
        }
        
    }
    
    private func loginUser(){
        
        showLoadingIndicator()
        User.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil{
                
                if isEmailVerified{
                    self.dismissView()
                }
                else{
                    self.hud.textLabel.text = "Please verify your email"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendButtonOutlet.isHidden = false
                }
            }
            else{
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            self.hideLoadingIndicator()
        }
        
    }
    
    private func resetThePassword(){
        
        User.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil{
                self.hud.textLabel.text = "Reset password email sent"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            else{
                self.hud.textLabel.text = error?.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
        
    }
    
    private func registerUser(){
        
        showLoadingIndicator()
        User.registerUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil{
                self.hud.textLabel.text = "Verification Email sent"
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
            
            self.hideLoadingIndicator()
        }
        
    }
    
    private func textFieldsHaveText()-> Bool{
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showLoadingIndicator(){
        if activityIndicator != nil{
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    private func hideLoadingIndicator(){
        if activityIndicator != nil{
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
}
