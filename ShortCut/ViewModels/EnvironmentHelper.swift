//
//  ViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift
class EnvironmentHelper: ObservableObject {
    @Published var customerId: String = ""
    @Published var name: String = "Kunde hinzufügen"
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var machineSpareList = [MachineSpare]()
    
    @Published var currentUser: User = User(id: "",  firstName: "", lastName: "", email: "", role: "",savedMachines: [""])
    @Published var currentMachine: Machine = Machine(id: "", orderDate: "", orderNumber: "", spareServiceEmail: "", spareServicePhone: "", warrantyBegin: "", warrantyEnd: "", installationEnd: "", krauseServiceEmail: "", deliveryDate: "", serialNumber: "", serviceEmail: "", serviceHotline: "", type: "", customerID: "", machineNumber: "")
    
    
    @Published var customerList = [Customer]()
    @Published var userList = [User]()
    @Published var machineStates = [MachineState]()
    init(){
    }
    
    
    func addUser(relatedUID: String, firstName: String, lastName: String, email: String, role: String){
            let db = Firestore.firestore()
        db.collection("Users").document(relatedUID).setData(["Vorname": firstName, "Nachname": lastName, "EMail": email,"Rolle": role, "Gespeicherte Maschinen": [String]()]){ error in
                if error == nil {
                    //Code for Succesfull creation of User
                }
                else{
                    //Handle Errors
                }
            }
        }
    
    
    
    
    func getAllUsers() {
        let db = Firestore.firestore()
        
        db.collection("Users").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.userList = snapshot.documents.compactMap{ d -> User? in
                            return try? (d.data(as: User.self))
                        }
                    }
                }
                else{
                    //handle Errors
                }
            }
        }
    }
    
    /*
    func getAllMachines() {
        let db = Firestore.firestore()
        
        db.collection("Machines").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    //update list view in the main thread
                    DispatchQueue.main.async {
                        self.machineList = snapshot.documents.map { d in
                            return Machine(id: d.documentID,
                                           customerId: d["CustomerID"] as? String ?? "",
                                           name: d["Name"] as? String ?? "",
                                           serialNumber: d["SerialNumber"] as? String ?? "",
                                           machineFileURL: d["MachineFileURL"] as? String ?? "",
                                           circuitDiagramURL: d["CircuitDiagramURL"] as? String ?? "",
                                           operationManualURL: d["OperationManualURL"] as? String ?? "")
                        }
                    }
                        
                }
                else {
                    //handle Errors
                }
            }
        }
    }*/
    
   
    func setCurrentUserByUID(UID: String){
        let db = Firestore.firestore()
        db.collection("Users").document(UID).getDocument{ document,error in
            if let document = document, document.exists{
                do{
                    self.currentUser = try document.data(as: User.self) ?? User(id: "", firstName: "", lastName: "", email: "", role: "", savedMachines: [""])
                }
                catch{
                    print(error)
                }
            }
        }
    }
    

    
    
    
    
    
    func setCurrentMachineByID(id: String){
        let db = Firestore.firestore()
        db.collection("Maschinen").document(id).getDocument{(document, error) in
            if let document = document, document.exists {
                let id = document.documentID
                let data = document.data()
                let orderDate = data?["Bestelldatum"] as? String ?? ""
                let orderNumber = data?["Bestellnummer"] as? String ?? ""
                let spareServiceEmail = data?["ErsatzteilEmail"] as? String ?? ""
                let spareServicePhone = data?["ErsatzteilTelefon"] as? String ?? ""
                let warrantyBegin = data?["Garantiebeginn"] as? String ?? ""
                let warrantyEnd = data?["Garantieende"] as? String ?? ""
                let installationEnd = data?["Installationsende"] as? String ?? ""
                let krauseServiceEmail = data?["KrauseServiceEmail"] as? String ?? ""
                let deliveryDate = data?["Liefertermin"] as? String ?? ""
                let serialNumber = data?["Seriennummer"] as? String ?? ""
                let serviceEmail = data?["ServiceEmail"] as? String ?? ""
                let serviceHotline = data?["ServiceHotline"] as? String ?? ""
                let type = data?["Typ"] as? String ?? ""
                let customerID = data?["KundenID"] as? String ?? ""
                let machineNumber = data?["Maschinennummer"] as? String ?? ""
                self.currentMachine = Machine(id: id, orderDate: orderDate, orderNumber: orderNumber, spareServiceEmail: spareServiceEmail, spareServicePhone: spareServicePhone, warrantyBegin: warrantyBegin, warrantyEnd: warrantyEnd, installationEnd: installationEnd, krauseServiceEmail: krauseServiceEmail, deliveryDate: deliveryDate, serialNumber: serialNumber, serviceEmail: serviceEmail, serviceHotline: serviceHotline, type: type,customerID: customerID, machineNumber: machineNumber)
            } else {
                self.currentMachine = Machine(id: "", orderDate: "", orderNumber: "", spareServiceEmail: "", spareServicePhone: "", warrantyBegin: "", warrantyEnd: "", installationEnd: "", krauseServiceEmail: "", deliveryDate: "", serialNumber: "", serviceEmail: "", serviceHotline: "", type: "",customerID: "", machineNumber: "")
                print("Document does not exist")
                }
            }
        }
    
    
    func getAllMachineSparesByMachineID(machineID: String){
        let db = Firestore.firestore()
        db.collection("Maschinenersatzteile").whereField("MaschinenID", isEqualTo: machineID).getDocuments { (snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.machineSpareList = snapshot.documents.map { document in
                                return MachineSpare(id: document.documentID, articleNumber: document["Artikelnummer"]as? String ?? "", machineID: document["MaschinenID"]as? String ?? "", wearIntervall: document["Verschleißintervall"]as? String ?? "")
                            }
                        }
                }
            }
        }
        
        
    }
    
}
