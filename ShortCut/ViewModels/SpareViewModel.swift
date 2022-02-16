//
//  SpareViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 14.02.22.
//

import Foundation
import Firebase

class SpareViewModel: ObservableObject {
    @Published var machineSpareList = [MachineSpare]()
    @Published var spareList = [Spare]()
    
    func addMachineSpare(articleNumber: String, description1GER: String, description2GER: String, description3GER: String, description1ENG: String, description2ENG: String, description3ENG: String, category: String, imageName: String){
        let db = Firestore.firestore()
        db.collection("Zustände").addDocument(data: ["Artikelnummer": articleNumber, "Bezeichnung 1 DEU": description1GER, "Bezeichnung 2 DEU": description2GER, "Bezeichnung 3 DEU": description3GER, "Bezeichnung 1 ENG": description1ENG, "Bezeichnung 2 ENG": description2ENG, "Bezeichnung 3 ENG": description3ENG, "Bild": imageName, "Kategorie": category]){
            error in
            if error == nil{
                print("Added new MachineState!")
            }else{
                print("Failed to create State!")
            }
            
        }
    }
    func getSingleSpareByArticleNumber(articleNumber: String){
        let db = Firestore.firestore()
        db.collection("Ersatzteile").document(articleNumber).getDocument{(document, error) in
            if let document = document, document.exists {
                let id = document.documentID
                let data = document.data()
                let description1ger = data?["Bezeichnung 1 DEU"] as? String ?? ""
                let description2ger = data?["Bezeichnung 2 DEU"] as? String ?? ""
                let description3ger = data?["Bezeichnung 3 DEU"] as? String ?? ""
                let description1eng = data?["Bezeichnung 1 ENG"] as? String ?? ""
                let description2eng = data?["Bezeichnung 2 ENG"] as? String ?? ""
                let description3eng = data?["Bezeichnung 3 ENG"] as? String ?? ""
                let imageName = data?["Bild"] as? String ?? ""
                let category = data?["Kategorie"] as? String ?? ""
                self.spareList.append(Spare(id: id, description1GER: description1ger, description2GER: description2ger, description3GER: description3ger, description1ENG: description1eng, description2ENG: description2eng, description3ENG: description3eng, category: category, imageName: imageName))
        } else {
            print("Document does not exist")
        }
        }
    }
}
