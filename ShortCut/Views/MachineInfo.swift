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
        ZStack(alignment: .top){
        CodeScannerView(
            codeTypes: [.qr],
            completion: {result in
                if case let .success(code) = result{
                
                self.scannedCode = code.string
                self.isPresentingScanner = false
                self.isPresentingMachineViewLink = true
                model.setCurrentMachineByID(id: scannedCode)
                model.getAllMachineSparesByMachineID(machineID: scannedCode)
                if model.currentMachine.id != ""{
                    self.representedText = model.currentMachine.id
                    }
                

                
            }
        })
            #if targetEnvironment(simulator)
            
            #else
            ZStack {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack{// destination
                Rectangle().frame(width: 300, height: 300)
                        .cornerRadius(30)
                        .blendMode(.destinationOut)
                
                    Text("Scannen Sie den QR- Code an der Maschine ein.").font(.body).foregroundColor(Color.white)
                }.offset(y: -120)
            }
            .compositingGroup()
            Text("QR-Code-Scanner").font(.largeTitle).foregroundColor(Color.white).fontWeight(.semibold)
            #endif
        }
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
                if isPresentingMachineViewLink && model.currentMachine.id != "" {
                    let presentedMachine: Machine = model.currentMachine
                    NavigationLink(destination: MachineMenu(machine: presentedMachine)){
                        Text("Maschineninformationen")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                    Spacer()
                        .frame(height: 30)
                }
                
                Button{
                    
                    self.isPresentingScanner = true
                } label: {
                    VStack{
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .padding(10)
                            Text("Scan Starten")
                                .font(.title)
                                .foregroundColor(Color.white)
                    }
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
