//
//  MachineInfo.swift
//  ShortCut
//
//  Created by Lisa Schmale on 21.12.21.
//

import SwiftUI
import Firebase
import CodeScanner

struct MachineInfo: View {
    @EnvironmentObject var model: ViewModel
    //@ObservedObject var model = ViewModel()
    @State var isPresentingScanner = false
    @State var isPresentingMachineViewLink = false
    @State var scannedCode: String = ""
    @State var representedText = "Scanne einen QR- Code."
    
   
    
    var scannerSheet: some View{
        CodeScannerView(
            codeTypes: [.qr],
            completion: {result in
                if case let .success(code) = result{
                
                self.scannedCode = code.string
                self.isPresentingScanner = false
                self.isPresentingMachineViewLink = true
                self.representedText = model.getMachineById(id: scannedCode).name
                model.currentMachine = model.getMachineById(id: scannedCode)
                
            }
        })
    }
    init(){
    }
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack{
                    
                Text(representedText)
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                if isPresentingMachineViewLink {
                    let presentedMachine: Machine = model.getMachineById(id: scannedCode)
                    NavigationLink(destination: MachineMenu(machine: presentedMachine)){
                        Text("Dokumente anzeigen")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(Color(hue: 0.59, saturation: 1.0, brightness: 0.692))
                    .cornerRadius(12)
                    Spacer()
                        .frame(height: 30)
                }
                
                Button{
                    
                    self.isPresentingScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .padding(10)
                }
                .sheet(isPresented: $isPresentingScanner){
                    self.scannerSheet
                }
                
                Spacer()
                
            }
        }
        //.frame( height: UIScreen.screenHeight - 100)
    }
}

struct MachineInfo_Previews: PreviewProvider {
    static var previews: some View {
        MachineInfo()
    }
}
