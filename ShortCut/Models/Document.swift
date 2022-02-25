//
//  Document.swift
//  ShortCut
//
//  Created by Bjarne Küper on 23.02.22.
//

import Foundation
import FirebaseFirestoreSwift
struct Document: Identifiable, Codable{
    @DocumentID var id: String?
    var description: String
    var documentType: String
    var machineNumber: String
    var language: String
    var URL: String
    var authorizedRoles: [String]
    
    enum CodingKeys: String, CodingKey{
        case id
        case description = "Bezeichnung"
        case documentType = "Dokumenttyp"
        case machineNumber = "Maschinennummer"
        case language = "Sprache"
        case URL = "URL"
        case authorizedRoles = "Autorisierte Rollen"
        
    }
}
