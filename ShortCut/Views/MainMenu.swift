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
    
    var body: some View {
        Text(String(model.savedMachines.count))
        TabView{
            FirebaseDemo()
                .tabItem{
                    Image(systemName: "flame")
                }.popover(isPresented: $isShowingWelcomePopover, content: {
                    WelcomeView(firstName: model.currentUser.firstName)
                })
            MachineInfo()
                .tabItem{
                    Image(systemName: "info.circle.fill")
            }
            CallClient()
                .tabItem{
                    Image(systemName: "phone.circle.fill")
                }
            /*ReportStatus()
                .tabItem{
                    Image(systemName: "envelope.fill")
                }*/
            DocumentArchive()
                .tabItem{
                    Image(systemName: "archivebox.circle.fill")
                }
        }.confirmationDialog("Wollen Sie sich wirklich ausloggen?", isPresented: $showConfirmationDialog,titleVisibility: .visible) {
            Button("Ausloggen",role: .destructive) {
                do{
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
