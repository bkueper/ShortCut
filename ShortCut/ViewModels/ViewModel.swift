//
//  ViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//

import Foundation
import Firebase
import CloudKit

class ViewModel: ObservableObject {
    @Published var customerId: String = ""
    @Published var name: String = "Kunde hinzufügen"
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var machineSpareList = [MachineSpare]()
    
    @Published var currentUser: User = User(id: "", relatedUID: "", firstName: "", lastName: "", email: "", role: "",savedMachines: [""])
    @Published var currentMachine: Machine = Machine(id: "", orderDate: "", orderNumber: "", spareServiceEmail: "", spareServicePhone: "", warrantyBegin: "", warrantyEnd: "", installationEnd: "", krauseServiceEmail: "", deliveryDate: "", serialNumber: "", serviceEmail: "", serviceHotline: "", type: "", customerID: "")
    @Published var machineList = [Machine]()
    @Published var customerList = [Customer]()
    @Published var userList = [User]()
    @Published var savedMachines = [String]()

    init(){
        getAllUsers()
        
    }
    
    func addMachineState(description: String, creatorUID: String, machineID: String, creationDate: Timestamp){
        let db = Firestore.firestore()
        db.collection("States").addDocument(data: ["Description": description, "CreatorUID": creatorUID, "MachineID": machineID, "CreationDate": creationDate]){
            error in
            if error == nil{
                self.getAllSavedMachinesOfUser(UID: self.currentUser.relatedUID)
                print("Added new MachineState!")
            }else{
                print("Failed to create State!")
            }
            
        }
    }
    
    
    func addUser(relatedUID: String, firstName: String, lastName: String, email: String, role: String){
        let db = Firestore.firestore()
        db.collection("Users").addDocument(data: ["RelatedUID": relatedUID, "FirstName": firstName, "LastName": lastName, "EMail": email,"Role": role, "SavedMachines": [String]()]){ error in
            if error == nil {
                self.getAllUsers()
            }
            else{
                //Handle Errors
            }
        }
    }
    
    func addCustomer(name: String, address: String, email: String, phoneNumber: String){
        let db = Firestore.firestore()
        db.collection("Customers").addDocument(data: ["Name":name, "Address":address, "Email":email, "Phonenumber":phoneNumber]){ error in
            if error == nil {
                //call getAllCustomers to update the UI
                self.getAllCustomers()
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
                        self.userList = snapshot.documents.map { d in
                            return User(id: d.documentID,
                                           relatedUID: d["RelatedUID"] as? String ?? "",
                                           firstName:  d["FirstName"] as? String ?? "",
                                           lastName: d["LastName"] as? String ?? "",
                                           email: d["EMail"] as? String ?? "",
                                        role: d["Role"] as? String ?? "",
                                        savedMachines: d["SavedMachines"] as? [String] ?? [""]  )
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
    func getAllCustomers() {
        let db = Firestore.firestore()

        db.collection("Customers").getDocuments { snapshot, error in
            
            if error == nil {
                
                if let snapshot = snapshot {
                    
                    //update list view in the main thread
                    DispatchQueue.main.async {
                        self.customerList = snapshot.documents.map { d in
                            return Customer(id: d.documentID,
                                            name: d["Name"] as? String ?? "",
                                            address: d["Address"] as? String ?? "",
                                            email: d["Email"] as? String ?? "",
                                            phoneNumber: d["Phonenumber"] as? String ?? "")
                        }
                    }
                        
                }
                else {
                    //handle Errors
                }
            }
        }
    }
    
        func getCustomerById(id: String) -> Customer{
        if let customer = customerList.first(where: {$0.id == id}){
            print(customer)
            return customer
        }else{
            print("Couldnt find a customer")
            return Customer(id: "Default", name: "Default", address: "Default", email: "Default", phoneNumber: "Default")
        }
    }
    
    
    func getUserByRelatedUID(UID: String) -> User{
        if let user = userList.first(where: {$0.relatedUID == UID}){
            return user
        }else{
            print("Couldnt find a user")
            return User(id: "Default", relatedUID: "Default",firstName: "Default",lastName: "Default",email: "Default",role: "Default",savedMachines: ["Default"])
        }
    }

    func addMachineToSavedMachines(ofUserID: String, MachineID: String){
        let db = Firestore.firestore()
        db.collection("Users").document(getUserByRelatedUID(UID: ofUserID).id).updateData([
    
            "SavedMachines": FieldValue.arrayUnion([MachineID])
        ])
        if(!valueAlreadyInArray(array: savedMachines, Value: MachineID)){
            self.savedMachines.append(MachineID)
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
    func getAllSavedMachinesOfUser(UID: String){
        savedMachines = getUserByRelatedUID(UID: UID).savedMachines
        print(savedMachines)
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
                self.currentMachine = Machine(id: id, orderDate: orderDate, orderNumber: orderNumber, spareServiceEmail: spareServiceEmail, spareServicePhone: spareServicePhone, warrantyBegin: warrantyBegin, warrantyEnd: warrantyEnd, installationEnd: installationEnd, krauseServiceEmail: krauseServiceEmail, deliveryDate: deliveryDate, serialNumber: serialNumber, serviceEmail: serviceEmail, serviceHotline: serviceHotline, type: type,customerID: customerID)
        } else {
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
                                return MachineSpare(id: document.documentID, arcticleNumber: document["Artikelnummer"]as? String ?? "", machineID: document["MaschinenID"]as? String ?? "", wearIntervall: document["Verschleißintervall"]as? String ?? "")
                            }
                        }
                }
            }
        }
        
        
    }
    
}
