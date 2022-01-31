//
//  DocumentArchive.swift
//  ShortCut
//
//  Created by Bjane Küper on 22.12.21.
//

import SwiftUI

struct DocumentArchive: View {
    
    var infoList = ["Maschine 1","Maschinenakte", "Bedienungsanleitung","Stückliste"]
    var allMachines: [[String]] = []
    init(allMachines: [[String]]){
        self.allMachines = allMachines
    }
    var body: some View {
        VStack {
            Text("Dokumentenarchiv")
                .font(.largeTitle)
            .fontWeight(.semibold)
            List(0..<allMachines.count, id: \.self){
                machine in
                MachineListElement(availableMachineInfo: allMachines[machine])
                
            }
        }
        
    }
}

struct MachineListElement: View {
    var availableMachineInfo: [String]
    var arraySize: Int
    init(availableMachineInfo: [String]){
        self.availableMachineInfo = availableMachineInfo
        self.arraySize = availableMachineInfo.count
    }
    var body: some View {
        VStack(alignment: .leading){
            Text(availableMachineInfo[0])
                .font(.title)
            ForEach(1..<availableMachineInfo.count) {
                i in MyButton(label:availableMachineInfo[i])
            }
            
        }
    }
}
struct DocumentArchive_Previews: PreviewProvider {
    static var previews: some View {
        DocumentArchive(allMachines: [["Maschine 1","Maschinenakte", "Bedienungsanleitung","Stückliste"],["Maschine 1","Maschinenakte", "Bedienungsanleitung","Stückliste"],["Maschine 1","Maschinenakte", "Bedienungsanleitung","Stückliste"]])
    }
}
