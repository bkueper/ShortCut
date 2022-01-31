//
//  MachineView.swift
//  ShortCut
//
//  Created by Bjarne Küper on 20.01.22.
//

import SwiftUI

struct MachineView: View{
    @EnvironmentObject var model: ViewModel
    var machine: Machine
    var showMachineFile: Bool = false
    var showCircuitDiagram: Bool = false
    var showOperationManual: Bool = false
    @State var isPresentingWebsiteSheet: Bool = false
    @State var documentURL: String = ""
    init(machine: Machine){
        self.machine = machine
        if (machine.machineFileURL != ""){
            self.showMachineFile = true
        }
        if (machine.circuitDiagramURL != ""){
            self.showCircuitDiagram = true
        }
        if (machine.operationManualURL != ""){
            self.showOperationManual = true
        }
    }
    
    var websiteSheet: some View{
        SwiftUIWebView(url: URL(string: documentURL))
    
    }
    var body: some View{
        
        VStack(alignment: .leading){
            Text(machine.name)
                .font(.title)
                .fontWeight(.bold)
            if showMachineFile{
                NavigationLink(destination: SwiftUIWebView(url: URL(string: machine.machineFileURL))){
                    Text("Maschinenakte")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color(hue: 0.59, saturation: 1.0, brightness: 0.692))
                .cornerRadius(4)
            }
            if showCircuitDiagram{
                NavigationLink(destination: SwiftUIWebView(url: URL(string: machine.circuitDiagramURL))){
                    Text("Schaltplan")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color(hue: 0.59, saturation: 1.0, brightness: 0.692))
                .cornerRadius(4)
            }
            if showOperationManual{
                NavigationLink(destination: SwiftUIWebView(url: URL(string: machine.operationManualURL))){
                    Text("Bedienungsanleitung")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color(hue: 0.59, saturation: 1.0, brightness: 0.692))
                .cornerRadius(4)
            }
            Button{
                model.addMachineToSavedMachines(ofUserID: model.currentUser.relatedUID, MachineID: machine.id)
                
            } label: {
                HStack{
                Text("Maschine speichern")
                        .font(.title)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(10)
                }
            }
            Spacer(minLength: 70)
        }
    }
    
    
}

struct MachineListSingleElement: View {
    var machine: Machine
    var customer: Customer
    init(machine: Machine, customer: Customer){
        self.machine = machine
        self.customer = customer
        
    }
    var body: some View {
        
        HStack{
            Image(systemName: "scanner.fill")
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading){
                Text(machine.name)
                    .font(.headline)
                    
                Text("Seriennummer: " + machine.serialNumber)
                    .font(.subheadline)
                
                Text("Kunde: " + customer.name)
                    .font(.subheadline)
            
                
            }
        }.onTapGesture{
        
            
        }
    }
}

struct MachineList: View {
    //@ObservedObject var model = ViewModel()
    @EnvironmentObject var model: ViewModel
    var body: some View {
        
        VStack {
            Text("Maschinen")
                .font(.largeTitle)
                .fontWeight(.semibold)
            List(0..<model.machineList.count, id: \.self){
                machine in
                VStack{
                    MachineListSingleElement(machine: model.machineList[machine], customer: model.getCustomerById(id: model.machineList[machine].customerId))
                }
            }
        }
    }
    init(){
        //model.getAllCustomers()
        //model.getAllMachines()
    }
}


