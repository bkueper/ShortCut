//
//  MachineStateViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 08.02.22.
//

import Foundation
import Firebase

class MachineStateViewModel: ObservableObject {
    @Published var currentMachineStates = [MachineState]()
    
    func deletemachineState(machineStateID: String, machineID: String){
        let db = Firestore.firestore()
        db.collection("Zustände").document(machineStateID).delete(){err in
            if let err = err{
                print("Error removing MachineState: \(err)")
            }else{
                self.getAllMachineStatesByMachineID(machineID: machineID)
                print("Suceessfully removed MachineState")
            }
        }
    }
    func addMachineState(description: String, creatorName: String, machineID: String, creationDate: Timestamp){
        let db = Firestore.firestore()
        db.collection("Zustände").addDocument(data: ["Beschreibung": description, "ErstellerName": creatorName, "MaschinenID": machineID, "Erstellungsdatum": creationDate]){
            error in
            if error == nil{
                self.getAllMachineStatesByMachineID(machineID: machineID)
                print("Added new MachineState!")
            }else{
                print("Failed to create State!")
            }
            
        }
    }
    func getAllMachineStatesByMachineID(machineID: String){
        let db = Firestore.firestore()
        db.collection("Zustände").whereField("MaschinenID", isEqualTo: machineID).getDocuments { (snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.currentMachineStates = snapshot.documents.map { document in
                                return MachineState(id: document.documentID, description: document["Beschreibung"]as? String ?? "", creatorName: document["ErstellerName"] as? String ?? "", machineID: document["MaschinenID"] as? String ?? "", creationDate: document["Erstellungsdatum"] as! Timestamp)
                            }
                            self.currentMachineStates.sort {$0.creationDate.dateValue() < $1.creationDate.dateValue()}
                        }
                }
            }
        }
    }

}

