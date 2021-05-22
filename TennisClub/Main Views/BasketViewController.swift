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
        
        if User.currentUser() != nil{
            if(User.currentUser()!.onBoard){
                if basket != nil {
                    purchasedItemIds = User.currentUser()!.purchasedItemIds
                    for item in basket!.itemIds{
                        purchasedItemIds.append(item)
                    }
                    print(purchasedItemIds)
                    updatePurchasedItems(withValues: [kPURCHASEDITEMIDS : purchasedItemIds])
                    
                    for i in basket!.itemIds{
                        removItemFromBasket(itemId: i)
                    }
                    
                    updateBasketInFirebase(basket!, withValues: [kITEMIDS:basket!.itemIds]) { (error) in
                        if error != nil{
                            print("error updating ", error!.localizedDescription)
                        }
                        
                        self.getBasketItems()
                    }
                    tableView.reloadData()
                }
            }
            else{
                self.hud.textLabel.text = "Please specify your details first"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
        }
        
    }
    
    private func loadBasketFromFirebase(){
        getBasketFromFirebase(User.currentId()) { (basket) in
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
    
    private func showItemView(withItem: Item){
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
        
    }
    
    private func checkOutButtonStatusUpdate(){
        
        if allItems.count > 0{
            checkOutButtonOutlet.isEnabled = true
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        else{
            disableCheckOutButton()
        }
        
    }
    
    private func disableCheckOutButton(){
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    private func removItemFromBasket(itemId: String){
        
        for i in 0..<basket!.itemIds.count{
            if itemId == basket!.itemIds[i]{
                basket!.itemIds.remove(at: i)
                return
            }
        }
        
    }
    private func updatePurchasedItems(withValues: [String:Any]){
        
        updateCurrentUserInFirebase(withValues: withValues) { (error) in
            
            if error != nil{
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            else{
                self.hud.textLabel.text = "Added to purchased items"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
        }
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removItemFromBasket(itemId: itemToDelete.id)
            
            updateBasketInFirebase(basket!, withValues: [kITEMIDS:basket!.itemIds]) { (error) in
                if error != nil{
                    print("error updating ", error!.localizedDescription)
                }
                
                self.getBasketItems()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
    
}
