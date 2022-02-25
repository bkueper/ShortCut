//
//  State.swift
//  ShortCut
//
//  Created by Bjarne Küper on 08.02.22.
//

import Foundation
import Firebase

struct MachineState: Identifiable{
    var id: String
    var description: String
    var creatorName: String
    var machineID: String
    var creationDate: Timestamp
}
