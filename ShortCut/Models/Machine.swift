//
//  Machine.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//

import Foundation

struct Machine: Identifiable{
    var id: String
    var customerId: String
    var name: String
    var serialNumber: String
    var machineFileURL: String
    var circuitDiagramURL: String
    var operationManualURL: String
}
