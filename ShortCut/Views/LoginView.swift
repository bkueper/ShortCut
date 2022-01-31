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
                            .onTapGesture {
                                print("Tapped!")
                                allowNavigation = false
                            }
                        if !isLoginMode {
                            TextField("Vorname", text: $firstName)
                            TextField("Nachname", text: $lastName)
                        }
                        SecureField("Passwort", text: $password)
                        if !isLoginMode {
                            SecureField("Passwort wiederholen", text: $passwordVerification)
                        }
                    }
                    .padding(12)
                    .background(Color.white)
                    NavigationLink(destination: MainMenu(),isActive: .constant(allowNavigation)) {
                        Button {
                            //model.getAllSavedMachinesOfUser(UID: "uVaYriS1vIWWht9Bap036ceAn602")
                            handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(isLoginMode ? "Log In" : "Account erstellen")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.blue)
                            
                        }
                    }
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Account erstellen")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }.navigationBarHidden(true)
            
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
                model.currentUser = User(id: "Default", relatedUID: result?.user.uid ?? "", firstName: firstName, lastName: lastName, email: email, role: "Standard",savedMachines: [""])
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
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            //model.currentUID = result?.user.uid ?? ""
            allowNavigation = false
            model.currentUser = model.getUserByRelatedUID(UID: result?.user.uid ?? "")
            model.getAllSavedMachinesOfUser(UID: result?.user.uid ?? "")
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
