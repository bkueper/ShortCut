//
//  MainMenu.swift
//  ShortCut
//
//  Created by Bjane Küper on 21.12.21.
//

import SwiftUI
import Firebase

struct MainMenu: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var environment: EnvironmentHelper
    @StateObject var savedMachinesViewModel = SavedMachinesViewModel()
    @State var isShowingWelcomePopover = true
    @State var showConfirmationDialog = false
    
    var body: some View {
            content
        
    }
    var content: some View {
        TabView{
            MachineInfo()
                .tabItem{
                    Image(systemName: "info.circle.fill")
                    }
                    .popover(isPresented: $isShowingWelcomePopover, content: {
                        WelcomeView(firstName: environment.currentUser.firstName)
                        })
            QRCodeGenerator()
                .tabItem{
                    Image(systemName: "qrcode")
                }
            DocumentArchive()
                .tabItem {
                    Image(systemName: "star.circle.fill")
                }
            if(environment.currentUser.role == "Hersteller Admin" || environment.currentUser.role == "Kunde Admin"){
                CreateAccount(currentUserRole: environment.currentUser.role)
                    .tabItem {
                        Image(systemName: "person.fill.badge.plus")
                    }
            }
        }.environmentObject(savedMachinesViewModel)
        .confirmationDialog("Wollen Sie sich wirklich ausloggen?", isPresented: $showConfirmationDialog,titleVisibility: .visible) {
            Button("Ausloggen",role: .destructive) {
                do{
                    environment.currentMachine = Machine(id: "", orderDate: "", orderNumber: "", spareServiceEmail: "", spareServicePhone: "", warrantyBegin: "", warrantyEnd: "", installationEnd: "", krauseServiceEmail: "", deliveryDate: "", serialNumber: "", serviceEmail: "", serviceHotline: "", type: "", customerID: "", machineNumber: "")
                    environment.currentUser = User(id: "", firstName: "", lastName: "", email: "", role: "", savedMachines: [""])
                    let currentUser = Auth.auth().currentUser?.uid
                    try Auth.auth().signOut()
                    print("Successfully logged out the User: \(String(describing: currentUser))")
                }catch{
                    print("Couldnt log out user.")
                }
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("Abbrechen",role: .cancel){}
        }
        .tint(Color.white)
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    self.showConfirmationDialog = true
                }label: {
                    Text("Ausloggen")
                }
            }
        
        }
    }
}

struct WelcomeView: View{
    var firstName: String = ""
    
    
    var body: some View{
        ScrollView{
            VStack(alignment: .center, spacing: 16){
                Spacer()
                Text("Hallo \(firstName)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Herzlich Willkommen zu ShortCut")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hue: 0.59, saturation: 1.0, brightness: 1.0))
                LottieView(fileName: "QRCodeScanningAnimation",isLooping: true)
                        .frame(width: 250, height: 250)
                Text("Scanne einen QR- Code einer Maschine, um verschiedene Aktionen auszuführen.")
                    .foregroundColor(Color(hue: 0.59, saturation: 1.0, brightness: 1.0))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding()
            }
            
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
