//
//  FirebaseCollectionReference.swift
//  TennisClub
//
//  Created by user191625 on 3/26/21.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String{
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference)-> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
