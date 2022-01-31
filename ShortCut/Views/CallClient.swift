//
//  CallClient.swift
//  ShortCut
//
//  Created by Bjane Küper on 21.12.21.
//

import SwiftUI
import CodeScanner

struct CallClient: View {
    //@ObservedObject var model = ViewModel()
    @EnvironmentObject var model: ViewModel
    @State var isPresentingScanner = false
    @State var scannedCode: String = ""
    @State var representedText = "Scanne einen QR- Code."
    @State var customerNumberFound = false
    var scannerSheet: some View{
        CodeScannerView(
            codeTypes: [.qr],
            completion: {result in
                if case let .success(code) = result{
                self.scannedCode = code.string
                self.isPresentingScanner = false
                self.customerNumberFound = true
                self.representedText = model.getCustomerById(id: model.getMachineById(id: scannedCode).customerId).name
            }
        })
    }
    
    init(){
        //model.getAllMachines()
        //model.getAllCustomers()
    }
    
    var body: some View {
        
        VStack {
            Text("Kunden anrufen")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(representedText)
                .font(.title)
                .fontWeight(.regular)
            Button{
                model.getAllMachines()
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
            if customerNumberFound{
                HStack{
                    Spacer()
                    Button{

                        if let url = URL(string: "tel://\(model.getCustomerById(id: model.getMachineById(id: scannedCode).customerId).phoneNumber)") {
                             UIApplication.shared.open(url)
                         }
                    } label: {
                        Image(systemName: "phone.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)
                    }

                    Spacer()
                    Button{
                        representedText = "Scanne einen QR- Code."
                        customerNumberFound = false
                    } label: {
                        Image(systemName: "phone.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
            }
            
            Spacer()
        }.frame(height: UIScreen.screenHeight - 100)
    }
}

struct CallClient_Previews: PreviewProvider {
    static var previews: some View {
        CallClient()
    }
}