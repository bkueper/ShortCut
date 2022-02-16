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
    
    func addMachineState(description: String, creatorUID: String, machineID: String, creationDate: Timestamp){
        let db = Firestore.firestore()
        db.collection("Zustände").addDocument(data: ["Beschreibung": description, "ErstellerUID": creatorUID, "MaschinenID": machineID, "Erstellungsdatum": creationDate]){
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
                                return MachineState(id: document.documentID, description: document["Beschreibung"]as? String ?? "", creatorUID: document["ErstellerUID"] as? String ?? "", machineID: document["MaschinenID"] as? String ?? "", creationDate: document["Erstellungsdatum"] as! Timestamp)
                            }
                            self.currentMachineStates.sort {$0.creationDate.dateValue() < $1.creationDate.dateValue()}
                        }
                }
            }
        }
    }

}

