//
//  CreateAccount.swift
//  ShortCut
//
//  Created by Bjarne Küper on 01.03.22.
//

import SwiftUI

import SwiftUI
import Firebase

struct CreateAccount: View {
    @EnvironmentObject var environment: EnvironmentHelper
    @State var email = ""
    @State var password = ""
    @State var passwordVerification = ""
    @State var statusMessage = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var allowNavigation = false
    @State var showConfirmationDialogue = false
    var states:[String] = [String]()
    @State private var selectedRole = "Hersteller User"
    init(currentUserRole: String){
        if(currentUserRole == "Hersteller Admin"){
            states = ["Hersteller User", "Hersteller Manager", "Hersteller Service", "Kunde User","Kunde Manager","Kunde Service"]
        }else if(currentUserRole == "Kunde Admin"){
            states = ["Kunde User","Kunde Manager","Kunde Service"]
        }
    }
    var body: some View {
            
            content
        
        
            
    }
    var content: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(Color.black.opacity(0.8))
                            .onTapGesture {
                                allowNavigation = false
                            }
                            .disableAutocorrection(true)
                            TextField("Vorname", text: $firstName)
                                .foregroundColor(Color.black.opacity(0.8))
                            TextField("Nachname", text: $lastName)
                                .foregroundColor(Color.black.opacity(0.8))
                        
                        SecureField("Passwort", text: $password)
                            .foregroundColor(Color.black.opacity(0.8))
                            SecureField("Passwort wiederholen", text: $passwordVerification)
                                .foregroundColor(Color.black.opacity(0.8))
                        
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(8)
                    .shadow(color: Color.black, radius: 3, x: 5, y:2 )
                    VStack(spacing: 10){
                        Text("Rolle festlegen").foregroundColor(Color.white).font(.title2).fontWeight(.semibold)
                        Picker("Wählen Sie die Rolle für den Nutzer", selection: $selectedRole) {
                                        ForEach(states, id: \.self) {
                                            Text($0)
                                                .foregroundColor(Color.black.opacity(0.8))
                                        }
                        }.pickerStyle(MenuPickerStyle())
                            .padding()
                            .foregroundColor(Color.black)
                            .background(Color.white.opacity(0.7))
                                .cornerRadius(8)
                                .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                    }
        
                        Button {
                            showConfirmationDialogue = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Account erstellen")
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
                    
                    Text(self.statusMessage)
                        .foregroundColor(.red)
                }.confirmationDialog("Wollen Sie den Nutzer \(firstName) \(lastName) erstellen?", isPresented: $showConfirmationDialogue,titleVisibility: .visible) {
                    Button("Hinzufügen",role: .destructive) {
                        createNewAccount()
                    }
                    Button("Abbrechen",role: .cancel){}
                }
                .padding()
                
            }
            .navigationTitle("Account erstellen").foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea())
            
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
    
    
    private func createNewAccount(){
        if(password == passwordVerification){
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to create user: ", err)
                    self.statusMessage = "Failed to create user: \(err)"
                    return
                }
                print("Successfully created user: \(result?.user.uid ?? "")")
                
                environment.addUser(relatedUID: result?.user.uid ?? "", firstName: firstName, lastName: lastName, email: email, role: selectedRole)
                email = ""
                firstName = ""
                lastName = ""
                password = ""
                passwordVerification = ""
                self.statusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            }
        }else{
            self.statusMessage = "Das Passwort und das wiederholte Passwort stimmen nicht überein"
            return
        }
    }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount(currentUserRole: "Hersteller Admin")
    }
}
