//
//  DocumentArchive.swift
//  ShortCut
//
//  Created by Bjane Küper on 22.12.21.
//

import SwiftUI
import Firebase
struct DocumentArchive: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        VStack {
            Text("Dokumentenarchiv")
                .font(.largeTitle)
                .fontWeight(.semibold)
            List(0..<model.savedMachines.count, id: \.self){
                machine in
                let machineToAdd = model.getMachineById(id: model.savedMachines[machine])
                MachineListSingleElement(machine: machineToAdd, customer: model.getCustomerById(id: machineToAdd.customerId))
                
                
            }
        }
        
    }
}


struct DocumentArchive_Previews: PreviewProvider {
    static var previews: some View {
        DocumentArchive()
    }
}
