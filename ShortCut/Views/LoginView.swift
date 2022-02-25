//
//  LoginView.swift
//  ShortCut
//
//  Created by Bjarne Küper on 27.01.22.
//
import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var model: ViewModel
    @State var isLoginMode = true
    @State var email = "bjarne.kueper@web.de"
    @State var password = "FCBayern2411"
    @State var passwordVerification = ""
    @State var loginStatusMessage = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var allowNavigation = false
    
    var body: some View {
            
            content
        
        
            
    }
    var content: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Account erstellen")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(Color.black.opacity(0.8))
                            .onTapGesture {
                                print("Tapped!")
                                allowNavigation = false
                            }
                        if !isLoginMode {
                            TextField("Vorname", text: $firstName)
                                .foregroundColor(Color.black.opacity(0.8))
                            TextField("Nachname", text: $lastName)
                                .foregroundColor(Color.black.opacity(0.8))
                        }
                        SecureField("Passwort", text: $password)
                            .foregroundColor(Color.black.opacity(0.8))
                        if !isLoginMode {
                            SecureField("Passwort wiederholen", text: $passwordVerification)
                                .foregroundColor(Color.black.opacity(0.8))
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(8)
                    .shadow(color: Color.black, radius: 3, x: 5, y:2 )
                    NavigationLink(destination: MainMenu(),isActive: .constant(allowNavigation)) {
                        Button {
                            //model.getAllSavedMachinesOfUser(UID: "uVaYriS1vIWWht9Bap036ceAn602")
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoginMode ? "Einloggen" : "Account erstellen")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color(.blue))
                                    .cornerRadius(8)
                                    .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                                    
                                Spacer()
                            }
                            
                        }.padding(.vertical,35)
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Account erstellen").foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea())
            
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func createNewAccount(){
        if(password == passwordVerification){
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to create user: ", err)
                    self.loginStatusMessage = "Failed to create user: \(err)"
                    return
                }
                print("Successfully created user: \(result?.user.uid ?? "")")
                
                model.addUser(relatedUID: result?.user.uid ?? "", firstName: firstName, lastName: lastName, email: email, role: "Standard")
                model.currentUser = User(id: result?.user.uid ?? "", firstName: firstName, lastName: lastName, email: email, role: "Standard",savedMachines: [""])
                Auth.auth().signIn(withEmail: email, password: password) { result, err in
                    if let err = err {
                        print("Failed to login user: ", err)
                        self.loginStatusMessage = "Failed to login user: \(err)"
                        return
                    }
                    print("Successfully logged in as user: \(result?.user.uid ?? "")")
                }
                email = ""
                firstName = ""
                lastName = ""
                password = ""
                passwordVerification = ""
                allowNavigation = true
            }
        }else{
            self.loginStatusMessage = "Das Passwort und das wiederholte Passwort stimmen nicht überein"
            return
        }
    }
    private func loginUser(){
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
                    if let err = err {
                        print("Failed to login user: ", err)
                        self.loginStatusMessage = "Failed to login user: \(err)"
                        return
                    }
            self.loginStatusMessage = ""
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            allowNavigation = false
            model.setCurrentUserByUID(UID: result?.user.uid ?? "")
            email = ""
            password = ""
            allowNavigation = true
        
        }
    }
}


struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
