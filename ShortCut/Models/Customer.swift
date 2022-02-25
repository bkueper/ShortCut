//
//  Customer.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//

import Foundation
import FirebaseFirestoreSwift
struct Customer: Identifiable, Codable{
    @DocumentID var id: String?
    var description1: String
    var description2: String
    var description3: String
    var country: String
    var city: String
    var postcode: String
    var street: String
    var contactPersons: [String]
    
    enum CodingKeys: String, CodingKey{
        case id
        case description1 = "Bezeichnung 1"
        case description2 = "Bezeichnung 2"
        case description3 = "Bezeichnung 3"
        case country = "Land"
        case city = "Ort"
        case postcode = "PLZ"
        case street = "Straße"
        case contactPersons = "Ansprechpartner"
    }
}
