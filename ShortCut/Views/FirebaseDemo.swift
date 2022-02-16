//
//  FirebaseDemo.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//
/*
import SwiftUI
import Firebase
struct FirebaseDemo: View {
    //@EnvironmentObject var customerInfo: CustomerInformation
    //@ObservedObject var model = ViewModel()
    @EnvironmentObject var model: ViewModel
    
    @State var name = ""
    @State var machineFileURL = ""
    @State var circuitDiagramURL = ""
    @State var operationManualURL = ""
    @State var serialNumber = ""

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1612174783, green: 0, blue: 0.5, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack{
                
                MachineList()
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8.0){
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Seriennummer", text: $serialNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Maschinenakte", text: $machineFileURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Schaltplan", text: $circuitDiagramURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Bedienungsanleitung", text: $operationManualURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    NavigationLink(destination: CustomerList()){
                        HStack{
                            Text(model.name)
                            Image(systemName: "person.text.rectangle.fill")
                        }
                    }
                }.padding()
                Button(action: {
                    model.addMachine(name: name, serialNumber: serialNumber, customerId: model.customerId,machineFileURL: machineFileURL,circuitDiagramURL: circuitDiagramURL, operationManualURL: operationManualURL)
                    
                    model.customerId = ""
                    model.name = "Kunde hinzufügen"
                    model.email = ""
                    model.address = ""
                    model.phoneNumber = ""
                    
                    name = ""
                    operationManualURL = ""
                    machineFileURL = ""
                    circuitDiagramURL = ""
                    serialNumber = ""
                    
                }, label: {
                    Text("Maschine hinzufügen")
                        .font(.headline)
                        .fontWeight(.bold)
                })
                Spacer()
            }
    }
    
    
}
    
}

*/


