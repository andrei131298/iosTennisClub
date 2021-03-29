//
//  Basket.swift
//  TennisClub
//
//  Created by user191625 on 3/29/21.
//

import Foundation

class Basket{
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    init() {
        
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
    
}

func getBasketFromFirebase(_ ownerId: String, completion: @escaping(_ Basket:Basket?) -> Void){
    
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerId).getDocuments{ (snapshot, error) in
        guard let snapshot = snapshot else{
            completion(nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else{
            completion(nil)
        }
        
    }
    
}

func saveBasketToFirebase(_ basket: Basket){
    
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryForm(basket) as! [String:Any])
    
}

func basketDictionaryForm(_ basket:Basket)->NSDictionary{
    
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying])
}

func updateBasketInFirebase(_ basket: Basket, withValues: [String: Any], completion: @escaping(_ error: Error?) -> Void){
    FirebaseReference(.Basket).document(basket.id).updateData(withValues){ (error) in
        completion(error)
    }
}
