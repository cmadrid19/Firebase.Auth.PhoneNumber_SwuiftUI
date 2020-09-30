//
//  FirstPage.swift
//  OTP
//
//  Created by Maxim Macari on 30/09/2020.
//

import SwiftUI
import Firebase

struct FirstPage: View {
    
    @State var ccode = ""
    @State var num = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    
    var body: some View {
        
        VStack(spacing: 20){
            
            Image("num")
                .resizable()
                .frame(width: 200, height: 200, alignment: .center)
            
            Text("Verify your number")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please enter your number to verify your account.")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top,  8)
            
            
            HStack{
                TextField("+1", text: $ccode)
                    .keyboardType(.numberPad)
                    .frame(width: 45)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                
                TextField("Number", text: $num)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }.padding(.top, 15)
            
            NavigationLink(destination: SecondPage(show: $show, ID: $ID), isActive: $show) {
                Button(action: {
                    
                    
                    //Only for tests
                    //remove this when testing with real phone number
                    //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                    
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode + self.num, uiDelegate: nil) { (ID, err) in
                        
                        if err != nil {
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                            
                        }
                        
                        self.ID = ID!
                        self.show.toggle()
                        
                    }
                    
                }) {
                    Text("Send")
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                }.foregroundColor(.white)
                .background(Color.green.opacity(0.95))
                .cornerRadius(10)
            }.navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
    
}
