//
//  Downloader.swift
//  TennisClub
//
//  Created by user191625 on 3/27/21.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks:[String]) -> Void){
    
    if Reachability.HasConnection(){
        
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images{
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil{
                    imageLinkArray.append(imageLink!)
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count{
                        completion(imageLinkArray)
                    }
                }
                
            }
            
            nameSuffix += 1
            
        }
        
    }
    else{
        print("no internet connection")
    }
}

func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping(_ imageLink: String?) -> Void){
    
    var task: StorageUploadTask!
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        if error != nil{
            print("error uploading image", error!.localizedDescription)
            completion(nil)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            guard let downloadUrl = url else{
                completion(nil)
                return
            }
            
            completion(downloadUrl.absoluteString)
        }
        
    })
    
}
