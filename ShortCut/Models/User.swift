//
//  User.swift
//  ShortCut
//
//  Created by Bjarne Küper on 27.01.22.
//


import Foundation
import FirebaseFirestoreSwift
struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var email: String
    var role: String
    var savedMachines: [String]
    
    enum CodingKeys: String, CodingKey{
        case id
        case firstName = "Vorname"
        case lastName = "Nachname"
        case email = "EMail"
        case role = "Rolle"
        case savedMachines = "Gespeicherte Maschinen"
    }
}
