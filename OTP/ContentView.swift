
import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
        VStack{
            
            if status {
                Home()
            }else{
                NavigationView{
                    FirstPage()
                }
            }
            
        }
        .onAppear(){
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){ _ in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                
                self.status = status
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
                    
                    self.sendNumber()
                    
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
    
    private func sendNumber(){
        
        PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode + self.num, uiDelegate: nil) { (ID, err) in
            
            if err != nil {
                self.msg = (err?.localizedDescription)!
                self.alert.toggle()
                return
                
            }
            
            self.ID = ID!
            self.show.toggle()
            
        }
    }
}


struct SecondPage: View {
    
    @State var code = ""
    @Binding var show: Bool
    @Binding var ID: String
    @State var msg = ""
    @State var alert = false
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            GeometryReader{ geo in
                VStack(spacing: 20){
                    
                    Image("num")
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                    
                    Text("Verification code")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding(.top, 25)
                    
                    Text("Please enter the verification code.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top,  8)
                    
                    
                    TextField("Code", text: self.$code)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color("Color"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 15)
                    
                    Button(action: {
                        
                        self.verifyCode()
                        
                    }) {
                        Text("Verify")
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    }.foregroundColor(.white)
                    .background(Color.green.opacity(0.95))
                    .cornerRadius(10)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    
                }
            }
            
            Button(action: {
                self.show.toggle()
                
            }) {
                Image(systemName: "chevron.left")
                    .font(.title)
                
            }.foregroundColor(.green).opacity(0.9)
        }
        .padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
    
    private func verifyCode(){
        
        let credential =
            PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
        
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil{
                self.msg = (err?.localizedDescription)!
                self.alert.toggle()
                return
            }
            
            UserDefaults.standard.setValue(true, forKey: "status")
            
            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            
        }
    }
}

struct Home: View {
    var body: some View{
        
        VStack{
            Text("Home")
            
            Button(action: {
                
                self.signOut()
                
            }) {
                
                Text("Logout")
            }
        }
    }
    private func signOut(){
        
        try! Auth.auth().signOut()
        
        UserDefaults.standard.set(false, forKey: "status")
        
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
        
    }
}
