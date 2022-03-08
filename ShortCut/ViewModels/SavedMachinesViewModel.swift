//
//  SavedMachinesViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 25.02.22.
//



import Foundation
import Firebase
import FirebaseFirestoreSwift
class SavedMachinesViewModel: ObservableObject{
    @Published var currentUser: User = User(id: "",  firstName: "", lastName: "", email: "", role: "",savedMachines: [""])
    @Published var savedMachinesList = [Machine]()
    var savedMachinesIDs = [String]()
    
    func deleteSavedMachine(machineID: String, userID: String){
        let db = Firestore.firestore()
        db.collection("Users").document(userID).updateData([
            "Gespeicherte Maschinen": FieldValue.arrayRemove([machineID])
        ])
        
    }
    
    func getAllSavedMachineIDsOfUser(UserId: String){
        let db = Firestore.firestore()
        
        db.collection("Users").document(UserId).getDocument { document, err in
            if let document = document, document.exists{
                DispatchQueue.main.async {
                    let data = document.data()
                    let machineIDs = data?["Gespeicherte Maschinen"] as? [String] ?? [""]
                    self.savedMachinesIDs = machineIDs
                }
            }
        }
    }
    
    
    func getAllSavedMachines(){
        let db = Firestore.firestore()
        
        for index in 0..<savedMachinesIDs.count{
            db.collection("Maschinen").document(savedMachinesIDs[index]).getDocument { document,error in
                if let document = document, document.exists{
                    DispatchQueue.main.async {
                        do{
                            self.savedMachinesList.append(try document.data(as: Machine.self) ?? Machine(id: "", orderDate: "", orderNumber: "", spareServiceEmail: "", spareServicePhone: "", warrantyBegin: "", warrantyEnd: "", installationEnd: "", krauseServiceEmail: "", deliveryDate: "", serialNumber: "", serviceEmail: "", serviceHotline: "", type: "", customerID: "", machineNumber: ""))
                        }
                        catch{
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func addMachineToSavedMachinesOfUser(MachineID: String,UserID: String){
        let db = Firestore.firestore()
        db.collection("Users").document(UserID).updateData([
    
            "Gespeicherte Maschinen": FieldValue.arrayUnion([MachineID])
        ])
        if(!valueAlreadyInArray(array: savedMachinesIDs, Value: MachineID)){
            self.savedMachinesIDs.append(MachineID)
        }
            
        
    }
    
    func valueAlreadyInArray(array: [String], Value: String) -> Bool{
        for element in array{
            if element == Value{
                return true
            }
        }
        return false
    }
}
