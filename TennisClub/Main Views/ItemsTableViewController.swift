//
//  ItemsTableViewController.swift
//  TennisClub
//
//  Created by user191625 on 3/27/21.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    var category: Category?
    
    var itemArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        self.title = category?.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil{
            //get items
            loadItems()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg"{
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    //MARK: load items

    private func loadItems(){
        
        getItemsFromFirebase(withCategoryId: category!.id) { (allItems) in
            
            self.itemArray = allItems
            self.tableView.reloadData()
        }
        
    }
}
