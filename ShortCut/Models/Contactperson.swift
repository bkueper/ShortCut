//
//  Contactperson.swift
//  ShortCut
//
//  Created by Bjarne Küper on 21.02.22.
//

import Foundation
import FirebaseFirestoreSwift
struct Contactperson: Identifiable, Codable{
    @DocumentID var id: String?
    var email: String
    var firstName: String
    var lastName: String
    var phonenumber1: String
    var phonenumber2: String
    var customerID: String
    enum CodingKeys: String, CodingKey{
        case id
        case email = "Email"
        case firstName = "Vorname"
        case lastName = "Nachname"
        case phonenumber1 = "Telefon 1"
        case phonenumber2 = "Telefon 2"
        case customerID = "KundenID"
        
    }
}
