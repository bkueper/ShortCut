//
//  CustomerViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 21.02.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
class CustomerViewModel: ObservableObject{
    @Published var currentMachineCustomer: Customer = Customer(id: "", description1: "", description2: "", description3: "", country: "", city: "", postcode: "", street: "", contactPersons: [""])
    @Published var customerContactpersons: [Contactperson] = [Contactperson]()
    
    func setCurrentMachineCustomer(customerID: String){
        let db = Firestore.firestore()
        db.collection("Kunden").document(customerID).getDocument{ document,error in
            if let document = document, document.exists{
                do{
                    self.currentMachineCustomer = try document.data(as: Customer.self) ?? Customer(id: "DEFAULT", description1: "DEFAULT", description2: "DEFAULT", description3: "DEFAULT", country: "DEFAULT", city: "DEFAULT", postcode: "DEFAULT", street: "DEFAULT", contactPersons: ["DEFAULT"])
                }
                catch{
                    print(error)
                }
            }
        }
    }
    func getAllContactPersonsByCustomerID(customerID: String){
        let db = Firestore.firestore()
        db.collection("Ansprechpartner").whereField("KundenID", isEqualTo: customerID).getDocuments { (snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.customerContactpersons = snapshot.documents.compactMap{ d -> Contactperson? in
                                return try? (d.data(as: Contactperson.self))
                            }
                        }
                }
            }
        }
    }
}
