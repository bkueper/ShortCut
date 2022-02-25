//
//  DocumentViewModel.swift
//  ShortCut
//
//  Created by Bjarne Küper on 23.02.22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
class DocumentViewModel: ObservableObject{
    @Published var documentList: [Document] = [Document]()
    
    func getAllDocumentsByMachineID(machineID: String){
        let db = Firestore.firestore()
        db.collection("Maschinendokumente").whereField("Maschinennummer", isEqualTo: machineID).getDocuments { (snapshot, err) in
            if err == nil {
                if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.documentList = snapshot.documents.compactMap{ d -> Document? in
                                return try? (d.data(as: Document.self))
                            }
                        }
                }
            }
        }
    }
}
