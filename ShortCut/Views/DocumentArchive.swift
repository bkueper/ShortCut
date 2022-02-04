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
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack {
                ScrollView(.vertical){
                    VStack(spacing: 10){
                        if (model.savedMachines.count > 0){
                            ForEach((1..<model.savedMachines.count), id: \.self) {machine in
                                let machineToAdd = model.getMachineById(id: model.savedMachines[machine])
                                MachineInfoView(machine: machineToAdd, customer: model.getCustomerById(id: machineToAdd.customerId)).padding()
                                }
                        }
                    }.frame( height: 500)
                        .padding()
                }
            }
        }
        
        
    }
}


struct DocumentArchive_Previews: PreviewProvider {
    static var previews: some View {
        DocumentArchive()
    }
}
