//
//  ViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/13/21.
//

import UIKit
import SideMenu

class ViewController: UIViewController, MenuControllerDelegate {
    

    private var sideMenu: SideMenuNavigationController?
    private var secondView : SecondViewController?
    private let settingsController = SettingsViewController()
    private let infoController = InfoViewController()
    
    @IBOutlet weak var cartImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuController(with: ["Home","Info","Settings"])
        
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        addChildControllers()
        
    }

    
    private func addChildControllers(){
        addChild(settingsController)
        addChild(infoController)
        
        view.addSubview(settingsController.view)
        view.addSubview(infoController.view)
        
        settingsController.view.frame = view.bounds
        infoController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        infoController.didMove(toParent: self)
        
        settingsController.view.isHidden = true
        infoController.view.isHidden = true


    }
    
    @IBAction func buttonClick(_ sender: Any) {
        performSegue(withIdentifier: "secondView", sender: self)
    }
    @IBAction func didTapMenuButton(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            
            self?.title = named
            
            if named == "Home"{
                self?.settingsController.view.isHidden = true
                self?.infoController.view.isHidden = true
            }
            else if named == "Info"{
                self?.settingsController.view.isHidden = true
                self?.infoController.view.isHidden = false
            }
            else if named == "Settings"{
                self?.settingsController.view.isHidden = false
                self?.infoController.view.isHidden = true
            }
            
        })
    }
    
}
