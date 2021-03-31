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
        
        if Auth.auth().currentUser != nil{
            return Auth.auth().currentUser!.uid
        }
        else{
            return ""
        }
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
                    getUserFromFirebase(userId: authDataResult!.user.uid, email: email)
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
    
    class func logoutUser(){
        
        do{
            try Auth.auth().signOut()
            
        }
        catch {
            print("already logged out")
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
    
    class func resetPasswordFor(email: String, completion: @escaping(_ error: Error?) -> Void){
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
            
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping(_ error:Error?) -> Void){
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print("resend email error", error?.localizedDescription)
                completion(error)
            })
        })
        
    }
    
}

func getUserFromFirebase(userId: String, email: String){
    
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        if snapshot.exists{
            saveUserLocally(userDictionary: snapshot.data()! as NSDictionary)
        }
        else{
            //save new user
            let user = User(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(userDictionary: userDictionaryForm(user: user))
            saveUserToFirebase(user: user)
        }
        
    }
    

}


func saveUserToFirebase(user: User){
    
    FirebaseReference(.User).document(user.objectId).setData(userDictionaryForm(user: user) as! [String: Any]) { (error) in
        if error != nil {
            print("error saving user")
        }
    }
}

func saveUserLocally(userDictionary: NSDictionary){
    UserDefaults.standard.set(userDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

func userDictionaryForm(user: User) -> NSDictionary{
    
    return NSDictionary(objects: [user.objectId,user.email,user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.purchasedItemIds], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying,
    kFULLADDRESS as NSCopying, kONBOARD as NSCopying, kPURCHASEDITEMIDS as NSCopying])
    
}

func updateCurrentUserInFirebase(withValues: [String:Any], completion: @escaping(_ error: Error?) -> Void){
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(User.currentId()).updateData(withValues) { (error) in
            completion(error)
            
            if error == nil {
                saveUserLocally(userDictionary: userObject)
            }
        }
    }
    
}
