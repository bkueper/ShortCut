//
//  SpareView.swift
//  ShortCut
//
//  Created by Bjarne Küper on 07.02.22.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import UIKit
import MessageUI
class SpareInformations: ObservableObject {
    @Published var spareValues = [Int]()
    func initializeSpareValues(spares: Int){
        for _ in 0...spares{
            spareValues.append(0)
        }
    }
}
struct SpareView: View {
    @EnvironmentObject var model: ViewModel
    @StateObject var spareInformations = SpareInformations()
    @ObservedObject private var spareViewModel = SpareViewModel()
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var showMailSheet = false
    @State var recievingEmailAdress: String = ""
//    @State var spareList: [Spare] = [Spare(id: "", itemNumber: "23", description: "Kabel", category: "Kabel", imageName: "Kabel.jpg"),Spare(id: "", itemNumber: "24", description: "Schanier", category: "Schaniere", imageName: "Schanier.jpg" ),
//                                     Spare(id: "", itemNumber: "25", description: "Schraube", category: "Schrauben", imageName: "Schraube.jpg" )]
    @State var singleSpareList: [SingleSpare] = [SingleSpare]()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Ersatzteile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                Form {
                    Section(header: Text("Ersatzteilliste").foregroundColor(Color.white), footer: Text("Fügen Sie alle gewünschten Ersatzteile hinzu.").foregroundColor(Color.white)){
                        ForEach((0..<spareViewModel.spareList.count), id: \.self){spare in
                            SingleSpare(name: spareViewModel.spareList[spare].description1GER, spareNumber: spare, imageName: spareViewModel.spareList[spare].imageName)
                            
                        }
                        }
                }
                .onAppear {
                    print(self.model.machineSpareList.count)
                    for index in 0..<(self.model.machineSpareList.count){
                        self.spareViewModel.getSingleSpareByArticleNumber(articleNumber: self.model.machineSpareList[index].arcticleNumber)
                    }
                    
                }
                .onDisappear {
                    self.spareViewModel.spareList.removeAll()
                }
                HStack{
                    Spacer()
                    Button{
                        recievingEmailAdress = model.currentMachine.spareServiceEmail
                        showMailSheet = true
                    }label: {
                        Text("Bestellen")
                            .foregroundColor(Color.white)
                    }
                    .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .shadow(color: Color.black, radius: 3, x: 5, y: 2)

                }
                }
            
            
            }
        .sheet(isPresented: $showMailSheet){
            MailView(result: self.$result, Subject: "Ersatzteilbestellung", MsgBody: createOrderText(),RecievingEMailAdress: self.$recievingEmailAdress)
        }
        .environmentObject(spareInformations)
        .onAppear {
            //TODO: Wenn Maschinenmodel die ANzahl der Erstzteile kennt diesen Wert übergeben
            spareInformations.initializeSpareValues(spares: 5)
        }
        }
    func createOrderText()->String{
        var orderText: String = "Hallo, \n wir benötigen folgende Ersatzteile: \n"
        for index in 0..<(spareViewModel.spareList.count){
            orderText += "\(spareInformations.spareValues[index])x \(spareViewModel.spareList[index].description1GER) \n"
        }
        return orderText
    }
}
struct SingleSpare: View {
    @EnvironmentObject var spareInformations: SpareInformations
    var name: String
    var spareNumber: Int
    var imageName: String
    @State var url = ""
    @State var amount: Int = 0
    
    var body: some View{
        HStack(alignment: .top){
            
            if url != ""{
                AnimatedImage(url: URL(string: url)!).resizable().frame(width: 64, height: 64).padding().cornerRadius(16)
            }else{
                Loader()
            }
            VStack(alignment: .leading){
            Text(name)
                .font(.body)

            Stepper("Anzahl: \(amount)", onIncrement: {
                spareInformations.spareValues[spareNumber] += 1
                amount += 1
            }, onDecrement: {
                if(amount >= 1){
                spareInformations.spareValues[spareNumber] -= 1
                    amount -= 1
                }
            })
            }
        }.onAppear {
            let storageRef = Storage.storage().reference()
            storageRef.child("Spares/\(imageName)").downloadURL{ (url, err) in
                if err != nil{
                    print((err?.localizedDescription)!)
                }
                self.url = "\(url!)"
            }
        }
    }
}
struct Loader: UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.startAnimating()
            return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>){
    }
    
    
}
struct SpareView_Previews: PreviewProvider {
    static var previews: some View {
        SpareView()
    }
}
