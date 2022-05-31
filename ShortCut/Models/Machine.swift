//
//  NewMachine.swift
//  ShortCut
//
//  Created by Bjarne Küper on 16.02.22.
//

import Foundation
import FirebaseFirestoreSwift
struct Machine: Identifiable, Codable{
    @DocumentID var id: String? 
    var orderDate: String
    var orderNumber: String
    var spareServiceEmail: String
    var spareServicePhone: String
    var warrantyBegin: String
    var warrantyEnd: String
    var installationEnd: String
    var krauseServiceEmail: String
    var deliveryDate: String
    var serialNumber: String
    var serviceEmail: String
    var serviceHotline: String
    var type: String
    var customerID: String
    var machineNumber: String
    var favorisedByUsersList: [String]
    enum CodingKeys: String, CodingKey{
        case id
        case orderDate = "Bestelldatum"
        case orderNumber = "Bestellnummer"
        case spareServiceEmail = "ErsatzteilEmail"
        case spareServicePhone = "ErsatzteilTelefon"
        case warrantyBegin = "Garantiebeginn"
        case warrantyEnd = "Garantieende"
        case installationEnd = "Installationsende"
        case krauseServiceEmail = "KrauseServiceEmail"
        case deliveryDate = "Liefertermin"
        case serialNumber = "Seriennummer"
        case serviceEmail = "ServiceEmail"
        case serviceHotline = "ServiceHotline"
        case type = "Typ"
        case customerID = "KundenID"
        case machineNumber = "Maschinennummer"
        case favorisedByUsersList = "FavorisiertVonUsernListe"
    }
}
