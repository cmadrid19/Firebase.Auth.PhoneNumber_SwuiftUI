//
//  Home.swift
//  OTP
//
//  Created by Maxim Macari on 30/09/2020.
//

import SwiftUI
import Firebase

struct Home: View {
    var body: some View{
        
        VStack{
            Text("Welcome \(UserDefaults.standard.value(forKey: "UserName") as! String)")
            
            Button(action: {
                
                try! Auth.auth().signOut()
                
                UserDefaults.standard.set(false, forKey: "status")
                
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
            }) {
                
                Text("Logout")
            }
        }
    }
}
