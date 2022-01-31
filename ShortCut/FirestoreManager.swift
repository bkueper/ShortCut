//
//  FirestoreManager.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//

import Foundation

import Firebase

class FirestoreManager: ObservableObject {
    @Published var customerName: String = ""
    
    init() {
        fetchCustomerName(customerName: <#T##String#>)()
    }

    func fetchCustomerName(customerName:String){
        let db = Firestore.firestore()
        
        let docRef = db.collection("Customers").document(customerName)
        
        docRef.getDocument{(document,error) in
            guard error == nil else{
                print("error", error ?? "")
                return
            }
            
            if let document = document, document.exists{
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.customerName = data["Name"] as? String ?? ""
                }
            }
            
        }
    }
}
