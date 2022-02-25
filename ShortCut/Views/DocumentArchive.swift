//
//  DocumentArchive.swift
//  ShortCut
//
//  Created by Bjane Küper on 22.12.21.
//

import SwiftUI
import Firebase
struct DocumentArchive: View {
    @EnvironmentObject var model: ViewModel
    @State var showNavigationLink = false
    @State var clickedMachineLinkMachineNumber: String = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text("Gespeicherte Maschinen")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                ScrollView(.vertical){
                        if (!model.savedMachinesList.isEmpty){
                            ForEach((0..<model.savedMachinesList.count), id: \.self) {machine in
                                let machineToAdd = model.savedMachinesList[machine]
                                MachineInfoView(machine: machineToAdd)
                                    .padding()
                                    .onTapGesture {
                                        showNavigationLink = true
                                        clickedMachineLinkMachineNumber = machineToAdd.machineNumber
                                        model.setCurrentMachineByID(id: machineToAdd.id ?? "")
                                        model.getAllMachineSparesByMachineID(machineID: machineToAdd.id ?? "")
                                }
                                }
                            }
                        }
                if(showNavigationLink){
                    NavigationLink(destination: MachineMenu()){
                        Text("Maschine \(clickedMachineLinkMachineNumber) anzeigen")
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
            }.onAppear {
                if(model.savedMachinesList.isEmpty){
                    //model.getAllSavedMachinesIDsOfCurrentUser()
                    model.getAllSavedMachinesOfCurrentUser()
                    
                }
                print(model.savedMachinesList)
            }
        }
    }
}


struct DocumentArchive_Previews: PreviewProvider {
    static var previews: some View {
        DocumentArchive()
    }
}


