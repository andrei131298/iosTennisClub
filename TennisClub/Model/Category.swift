//
//  Category.swift
//  TennisClub
//
//  Created by user191625 on 3/26/21.
//

import Foundation
import UIKit

class Category  {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name:String,_imageName:String){
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//get category
func getCategoriesFromFirebase(completion: @escaping (_ categoryArray:[Category])->Void){
    
    var categoryArray: [Category] = []
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else{
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty{
            
            for categoryDictionary in snapshot.documents{
                print("created new category")
                categoryArray.append(Category(_dictionary: categoryDictionary.data() as NSDictionary))

            }
        }
        
        completion(categoryArray)
    }
}

//Save category function
func saveCategoryToFirebase(_ category: Category){
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryForm(category) as! [String : Any])
}

//Helpers

func categoryDictionaryForm(_ category:Category)->NSDictionary{
    
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//use only one time
//func createCategorySet(){
//
//    print("daaa")
//    let rackets = Category(_name: "Rackets", _imageName: "racket")
//    let apparel = Category(_name: "Apparel", _imageName: "apparel")
//    let shoes = Category(_name: "Shoes", _imageName: "shoes")
//    let bags = Category(_name: "Bags", _imageName: "bags")
//    let strings = Category(_name: "Strings", _imageName: "strings")
//    let grips = Category(_name: "Grips", _imageName: "grips")
//    let accessories = Category(_name: "Accessories", _imageName: "accessories")
//    let balls = Category(_name: "Balls", _imageName: "Balls")
//
//
//
//
//    let arrayOfCategories = [rackets,apparel,shoes,bags,strings,grips,accessories,balls]
//
//    for category in arrayOfCategories{
//        saveCategoryToFirebase(category)
//    }
//}
