//
//  BasketViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/29/21.
//

import UIKit
import JGProgressHUD
class BasketViewController: UIViewController {

    @IBOutlet weak var basketTotalPriceLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds: [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = footerView
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        loadBasketFromFirebase()
        
    }
    

    @IBAction func checkOutButtonPressed(_ sender: Any) {
        
        
        
    }
    
    private func loadBasketFromFirebase(){
        getBasketFromFirebase("1234") { (basket) in
            self.basket = basket
            self.getBasketItems()
            
        }
    }
    
    private func getBasketItems(){
        if basket != nil {
            getItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotal(false)
                self.tableView.reloadData()
            }
        }
    }
    
    private func updateTotal(_ isEmpty: Bool){
        
        if isEmpty{
            totalItemsLabel.text = "0"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
        }
        else{
            totalItemsLabel.text = "\(allItems.count)"
            basketTotalPriceLabel.text = returnBasketTotalPrice()
        }
        
        checkOutButtonStatusUpdate()
        
    }
    
    private func returnBasketTotalPrice() -> String{
        var totalPrice = 0.0
        
        for item in allItems{
            totalPrice += item.price
        }
        return "Total price: " + convertToCurrency(totalPrice)
    }
    
    private func checkOutButtonStatusUpdate(){
        
        checkOutButtonOutlet.isEnabled = allItems.count > 0
        
        if checkOutButtonOutlet.isEnabled{
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else{
            
        }
        
    }
    
    private func disableCheckOutButton(){
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    
}
