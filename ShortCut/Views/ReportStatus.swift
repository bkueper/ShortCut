//
//  ReportStatus.swift
//  ShortCut
//
//  Created by Bjarne Küper on 21.12.21.
//

import SwiftUI
import Firebase
import CodeScanner

struct ReportStatus: View {
    @EnvironmentObject var model: ViewModel
    @ObservedObject private var machineStateViewModel = MachineStateViewModel()
    @State var showConfirmationDialog: Bool = false
    @State private var customStateText: String = ""
    var states = ["Benutzerdefiniert", "Maschine angelegt", "Montagebeginn", "Elektrik ok","Montageende","Inbetriebname ok","Verpackt","Versendet","Angeliefert","Installiert","Wartung planen","Wartung durchgeführt","Störung gemeldet","Störung behoben"]
    @State private var selectedState = "Benutzerdefiniert"
    var machineStates = [MachineState]()
    var body: some View {
        ZStack(alignment: .center){
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
                    VStack(alignment: .leading){
                        List {
                            if(machineStateViewModel.currentMachineStates.count > 0){
                                ForEach((0..<machineStateViewModel.currentMachineStates.count), id: \.self) {machine in
                                    HStack{
                                        StatusListElement(machineState: machineStateViewModel.currentMachineStates[machine]).padding()
                                        }
                                    }
                                }
                        }.onAppear {
                            self.machineStateViewModel.getAllMachineStatesByMachineID(machineID: model.currentMachine.id)
                        }
                        Spacer()
                        Section(header: Text("Bauzustand").foregroundColor(Color.white), footer: Text("Wählen Sie einen der Bauzustände aus. Wählen Sie benutzdefiniert aus um einen eigenen Bauzustand zu beschreiben.").foregroundColor(Color.white)){
                            Picker("Wählen Sie einen Bauzustand", selection: $selectedState) {
                                            ForEach(states, id: \.self) {
                                                Text($0)
                                            }
                            }.pickerStyle(WheelPickerStyle())
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                        }
                        
                            
                        if(selectedState == "Benutzerdefiniert"){
                            TextField("Bauzustand beschreiben", text: $customStateText)
                                .padding()
                                .background()
                                .cornerRadius(8)
                                .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                                
                        }
                            HStack{
                                Spacer()
                                Button{
                                    showConfirmationDialog = true
                                }label: {
                                    Text("Bauzustand hinzufügen")
                                        .foregroundColor(Color.white)
                                }
                                .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .shadow(color: Color.black, radius: 3, x: 5, y: 2)

                            }
                        
                    }.confirmationDialog("Wollen Sie den Bauzustand \(selectedState) hinzufügen?", isPresented: $showConfirmationDialog,titleVisibility: .visible) {
                        Button("Hinzufügen",role: .destructive) {
                            if(selectedState != "Benutzerdefiniert"){
                                machineStateViewModel.addMachineState(description: selectedState, creatorUID: model.currentUser.relatedUID, machineID: model.currentMachine.id, creationDate: Timestamp.init())
                            }else{
                                machineStateViewModel.addMachineState(description: customStateText, creatorUID: model.currentUser.relatedUID, machineID: model.currentMachine.id, creationDate: Timestamp.init())
                            }
                                selectedState = "Benutzerdefiniert"
                                customStateText = ""
                                print("Successfully added MachineState")
                        }
                        Button("Abbrechen",role: .cancel){}
                    }
                
            }
    
    }
}
struct StatusListElement: View{
    @EnvironmentObject var model: ViewModel
    var machineState: MachineState
    init(machineState: MachineState){
        self.machineState = machineState
    }
    var body: some View{
        HStack(alignment:.bottom){
            VStack(alignment:.leading){
                Text(machineState.description)
                    .font(.body)
                    .fontWeight(.semibold)
                Text("Von \(model.getUserByRelatedUID(UID: machineState.creatorUID).firstName) \(model.getUserByRelatedUID(UID: machineState.creatorUID).lastName)")
                    .font(.caption)
            }
            Spacer()
            Text(machineState.creationDate.dateValue().toString(dateFormat: "dd-MM-yyyy HH:mm")).font(.caption)
        }
    }
}

struct ReportStatus_Previews: PreviewProvider {
    static var previews: some View {
        ReportStatus()
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
