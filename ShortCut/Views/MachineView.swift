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
                    Image(systemName: "plus.circle.fill")
                    
                }.font(.title)
            }
            Spacer(minLength: 70)
            }
            
    }
    
    
}
struct MachineInfoView: View {
    var machine: Machine
    var customer: Customer
    init(machine: Machine, customer: Customer){
        self.machine = machine
        self.customer = customer
        
    }
    var body: some View {
            
            VStack{
                ZStack(alignment: .topLeading){
                    Color.white.opacity(0.60)
                        .cornerRadius(8)
                        .shadow(radius: 8)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text(machine.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                .foregroundColor(Color.black.opacity(0.7))
                            Text("Seriennummer: \(machine.serialNumber)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                        Spacer()
                        VStack(alignment: .leading){
                            Text("Kunde: \(customer.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                .foregroundColor(Color.black.opacity(0.7))
                            HStack{
                                HStack{
                                    Image(systemName: "mail.fill")
                                    Text(customer.email)
                                    }.foregroundColor(Color.black.opacity(0.7))
                                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                HStack{
                                    Image(systemName: "phone.fill")
                                    Text("Kundentelefonummer")
                                    }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                        .foregroundColor(Color.black.opacity(0.7))
                            }
                        }
                        }
                }.frame(width: 384, height: 100)
            }
        }
}


struct MachineList: View {
    //@ObservedObject var model = ViewModel()
    @EnvironmentObject var model: ViewModel
    var body: some View {
        
    ScrollView(.vertical){
        VStack(spacing: 10){
            ForEach((1..<model.machineList.count), id: \.self) {machine in
                MachineInfoView(machine: model.machineList[machine], customer: model.getCustomerById(id: model.machineList[machine].customerId)).padding()
                }
        }.frame( height: 500)
            .padding()
    }
//            List(0..<model.machineList.count, id: \.self){
//                machine in
//                VStack{
//                    MachineInfoView(machine: model.machineList[machine], customer: model.getCustomerById(id: model.machineList[machine].customerId))
//                }
//            }
       
    }
    init(){
        //model.getAllCustomers()
        //model.getAllMachines()
    }
}


