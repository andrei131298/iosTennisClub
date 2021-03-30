//
//  User.swift
//  TennisClub
//
//  Created by user191625 on 3/30/21.
//

import Foundation
import FirebaseAuth

class User{
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    init(_objectId: String, _email:String, _firstName:String, _lastName: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
        
    }
    
    init(_dictionary: NSDictionary){
        
        objectId = _dictionary[kOBJECTID] as! String
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else{
            email = ""
        }
        
        if let fname = _dictionary[kFIRSTNAME] {
            firstName = fname as! String
        } else{
            firstName = ""
        }
        
        if let lname = _dictionary[kLASTNAME] {
            lastName = lname as! String
        } else{
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[kFULLADDRESS] {
            fullAddress = faddress as! String
        } else{
            fullAddress = ""
        }
        
        if let onB = _dictionary[kONBOARD] {
            onBoard = onB as! Bool
        } else{
            onBoard = false
        }
        
        if let purchaseIds = _dictionary[kPURCHASEDITEMIDS] {
            purchasedItemIds = purchaseIds as! [String]
        } else{
            purchasedItemIds = []
        }
    }
    
    class func currentId() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User?{
        if Auth.auth().currentUser != nil{
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    class func loginUserWith(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil{
                if authDataResult!.user.isEmailVerified{
                    //get user from Firebase
                    completion(error, true)
                }
                else{
                    print("email not verified")
                    completion(error, false)
                }
            }
            else{
                completion(error, false)
            }
        }
    }
    
    class func registerUserWithEmail(email: String, password: String, completion: @escaping(_ error: Error?) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil{
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error: ", error?.localizedDescription)
                }
            }
            
            
        }
        
    }
}
