//
//  CheckUser.swift
//  OTP
//
//  Created by Maxim Macari on 30/09/2020.
//

import SwiftUI
import Firebase
import FirebaseFirestore

func CheckUser(completion: @escaping (Bool, String) -> Void){
    let db = Firestore.firestore()
    
    db.collection("users").getDocuments { (snap, err) in
        
        if err != nil {
            
            print((err?.localizedDescription)!)
            return
        }
        
        for i in snap!.documents{
            
            if i.documentID == Auth.auth().currentUser?.uid {
                completion(true, i.get("name") as! String)
                return
            }
        }
        
        completion(false, "")
        
    }
}
