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
    @EnvironmentObject var model: ViewModel
    @State var isShowingWelcomePopover = true
    @State var showConfirmationDialog = false
    init(){
        UITabBar.appearance().barTintColor = UIColor.blue
        
    }
    var body: some View {
            content
        
    }
    
    var content: some View {
        TabView{
            
            NavigationView{
                MachineInfo()
                    .navigationTitle("Maschineninfo")
            }
                .tabItem{
                    Image(systemName: "info.circle.fill")
                }
                .popover(isPresented: $isShowingWelcomePopover, content: {
                    WelcomeView(firstName: model.currentUser.firstName)
                })
            NavigationView{
                CallClient()
                    .navigationTitle("Kunden anrufen")
            }
                    .tabItem{
                        Image(systemName: "phone.circle.fill")
                    }
            NavigationView{
                ReportStatus()
                    .navigationTitle("Bauzustand melden")
            }
                .tabItem{
                    Image(systemName: "envelope.fill")
                }
            NavigationView{
                DocumentArchive()
                    .navigationTitle("Gespeicherte Maschinen")
            }
                .tabItem{
                    Image(systemName: "archivebox.circle.fill")
                }
            if model.currentUser.role == "Admin" {
                NavigationView{
                    FirebaseDemo()
                        .navigationTitle("Admineinstellungen")
                }
                    .tabItem{
                        Image(systemName: "flame")
                    }
            }
        }.confirmationDialog("Wollen Sie sich wirklich ausloggen?", isPresented: $showConfirmationDialog,titleVisibility: .visible) {
            Button("Ausloggen",role: .destructive) {
                do{
                    model.savedMachines.removeAll()
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
        .navigationTitle("")
        .navigationBarHidden(true)
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
