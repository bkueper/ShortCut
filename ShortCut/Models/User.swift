//
//  User.swift
//  ShortCut
//
//  Created by Bjarne Küper on 27.01.22.
//

import SwiftUI
import Foundation

struct User: Identifiable{
    var id: String
    var relatedUID: String
    var firstName: String
    var lastName: String
    var email: String
    var role: String
    var savedMachines: [String]
}
