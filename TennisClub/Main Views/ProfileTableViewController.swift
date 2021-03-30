//
//  ProfileTableViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/30/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var finishRegistrationButton: UIButton!
    @IBOutlet weak var purchaseHistoryButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var editButtonOutlet: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check logged in status
        checkLoginStatus()
        checkOnBoardingStatus()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func checkOnBoardingStatus(){
        
        if User.currentUser() != nil{
            if User.currentUser()!.onBoard{
                finishRegistrationButton.setTitle("Account is active", for: .normal)
                finishRegistrationButton.isEnabled = false
            }
            else{
                finishRegistrationButton.setTitle("Finish registration", for: .normal)
                finishRegistrationButton.isEnabled = true
                finishRegistrationButton.tintColor = .red
            }
        }
        else{
            finishRegistrationButton.setTitle("Logged out", for: .normal)
            finishRegistrationButton.isEnabled = false
            purchaseHistoryButton.isEnabled = false
        }
    }
    
    private func checkLoginStatus(){
        if User.currentUser() == nil{
            createRightBarButton(title: "Login")
            logOutButton.isHidden = true
        }
        else{
            createRightBarButton(title: "Edit")
            logOutButton.isHidden = false
        }
    }

    private func createRightBarButton(title: String){
        
        editButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        self.navigationItem.rightBarButtonItem = editButtonOutlet
    }
    
    @objc func rightBarButtonPressed(){
        print(editButtonOutlet)
        if editButtonOutlet!.title == "Login" {
            //show login view
            showLoginView()
        }
        else{
            goToEditProfile()
            
        }
    }

   
    @IBAction func logOutButtonPressed(_ sender: Any) {
        User.logoutUser()
        self.tableView.reloadData()
    }
    
    private func showLoginView(){
        
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func goToEditProfile(){
        
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }


}
