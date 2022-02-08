//
//  ReportStatusView.swift
//  ShortCut
//
//  Created by Bjarne Küper on 01.02.22.
//

import SwiftUI

struct ReportStatusView: View {
    @EnvironmentObject var model: ViewModel
    @State var statusText: String = ""
    @State private var isShowingPhotoPicker = false
    @State private var pickedImage = UIImage(systemName: "p.circle")
    
    var machine: Machine
    init(machine: Machine){
        self.machine = machine
    }
    var body: some View {
        VStack(alignment: .leading){
            Text("Bauzustand von \(machine.name) melden.")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(alignment: .top)
            TextEditor(text: $statusText)
                .frame(width: .infinity, height: 100)
                .border(.blue)
            HStack{
                Text("Foto hinzufügen")
                Image(systemName: "photo")
            }.foregroundColor(.blue)
            .onTapGesture {
                isShowingPhotoPicker = true
            }
            
            Image(uiImage: pickedImage!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding()
            
        }
        
        
    }
}


