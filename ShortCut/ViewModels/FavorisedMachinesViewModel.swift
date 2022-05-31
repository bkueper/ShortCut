//
//  SavedMachinesViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 25.02.22.
//



import Foundation
import Firebase
import FirebaseFirestoreSwift
class FavorisedMachinesViewModel: ObservableObject{
    @Published var currentUser: User = User(id: "",  firstName: "", lastName: "", email: "", role: "",savedMachines: [""])
    @Published var savedMachinesList = [Machine]()
    var savedMachinesIDs = [String]()
    
    func deleteSavedMachine(machineID: String, userID: String){
        let db = Firestore.firestore()
        db.collection("Maschinen").document(machineID).updateData([
            "FavorisiertVonUsernListe": FieldValue.arrayRemove([userID])
        ])
        getAllFavorisedMachinesByUserID(userId: userID)
    }
    
   
    
    func getAllFavorisedMachinesByUserID(userId: String){
        let db = Firestore.firestore()
        
        db.collection("Maschinen").whereField("FavorisiertVonUsernListe", arrayContains: userId).getDocuments{(snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.savedMachinesList = snapshot.documents.compactMap{ d -> Machine? in
                                return try? (d.data(as: Machine.self))
                            }
                        }
                }
            }
            
        }
    }
    
    
    func addUserIDToFavorisedByUsersList(MachineID: String, UserID: String){
        let db = Firestore.firestore()
        db.collection("Maschinen").document(MachineID).updateData([
            "FavorisiertVonUsernListe": FieldValue.arrayUnion([UserID])
        ])
    }
}
