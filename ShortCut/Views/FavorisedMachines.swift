//
//  DocumentArchive.swift
//  ShortCut
//
//  Created by Bjane Küper on 22.12.21.
//

import SwiftUI
import Firebase
struct FavorisedMachines: View {
    @EnvironmentObject var environment: EnvironmentHelper
    @EnvironmentObject var savedMachinesViewModel: FavorisedMachinesViewModel
    @State var showNavigationLink = false
    @State var showDeleteRequest = false
    @State var clickedMachineLinkMachineID: String = ""
    @State var longPressedMachineID: String = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text("Favoriten")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                ScrollView(.vertical){
                        if (!savedMachinesViewModel.savedMachinesList.isEmpty){
                            ForEach((0..<savedMachinesViewModel.savedMachinesList.count), id: \.self) {machine in
                                let machineToAdd = savedMachinesViewModel.savedMachinesList[machine]
                                MachineInfoView(machine: machineToAdd)
                                    .padding()
                                    .onTapGesture {
                                        showNavigationLink = true
                                        clickedMachineLinkMachineID = machineToAdd.id ?? ""
                                        environment.setCurrentMachineByID(id: machineToAdd.id ?? "")
                                        environment.getAllMachineSparesByMachineID(machineID: machineToAdd.id ?? "")
                                    }
                                    .onLongPressGesture{
                                        simpleVibration()
                                        longPressedMachineID = machineToAdd.id ?? ""
                                        showDeleteRequest = true
                                    }
                                    
                            }
                        }
                    
                Spacer()
                    
                if(showNavigationLink){
                    NavigationLink(destination: MachineMenu()){
                        Text("Maschine \(clickedMachineLinkMachineID) anzeigen")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                }
            }
            .onAppear {
                savedMachinesViewModel.getAllFavorisedMachinesByUserID(userId: environment.currentUser.id ?? "")
                }
            }
            .confirmationDialog("Wollen Sie die Maschine \(longPressedMachineID) aus Favoriten entfernen?", isPresented: $showDeleteRequest,titleVisibility: .visible) {
                Button("Maschine entfernen",role: .destructive) {
                    savedMachinesViewModel.deleteSavedMachine(machineID: longPressedMachineID, userID: environment.currentUser.id ?? "")
                    print("Maschine entfernt")
                }
                Button("Abbrechen",role: .cancel){}
            }
        }
    }
    func simpleVibration() {
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
        impactMed.impactOccurred()
    }
}





