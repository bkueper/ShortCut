//
//  MachineView.swift
//  ShortCut
//
//  Created by Bjarne Küper on 20.01.22.
//

import SwiftUI
import UIKit
import MessageUI
import Firebase

struct MachineInfoView: View {
    var machine: Machine
    //var customer: Customer
    init(machine: Machine){
        self.machine = machine
        //self.customer = customer
        
    }
    var body: some View {
                VStack{
                    ZStack(alignment: .topLeading){
                        Color.blue.opacity(0.80)
                            .cornerRadius(8)
                            .shadow(radius: 8)
                        VStack(alignment: .center){
                            VStack(alignment: .leading){
                                Text("Maschine: \(machine.id ?? "")")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    .foregroundColor(Color.white)
                                Text("Typ: \(machine.type)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    .foregroundColor(Color.white)
                                Text("Bestellnummer: \(machine.orderNumber)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    .foregroundColor(Color.white)
                                Text("Seriennummer: \(machine.serialNumber)")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    .foregroundColor(Color.white)
                            }
                            /*
                            Spacer()
                            VStack(alignment: .leading){
                                Text("Kunde: \(customer.name)")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    .foregroundColor(Color.black.opacity(0.7))
                                HStack{
                                    HStack{
                                        Image(systemName: "mail.fill")
                                        Text(customer.description1)
                                        }.foregroundColor(Color.black.opacity(0.7))
                                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                    HStack{
                                        Image(systemName: "phone.fill")
                                        Text("Kundentelefonummer")
                                        }.padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                                            .foregroundColor(Color.black.opacity(0.7))
                                }
                            }*/
                            }
                    }//.frame(width: 384, height: 100)
                }
            
        }
}

/*
struct MachineList: View {
    @EnvironmentObject var model: ViewModel
    var body: some View {
        
    ScrollView(.vertical){
        //VStack(spacing: 10){
            ForEach((1..<model.machineList.count), id: \.self) {machine in
                MachineInfoView(machine: model.machineList[machine], customer: model.getCustomerById(id: model.machineList[machine].customerId)).padding()
                }
            //}.frame( height: 200)
                
        }
    }
}
*/
struct MachineMenu: View {
    @EnvironmentObject var environment: EnvironmentHelper
    @ObservedObject private var customerViewModel = CustomerViewModel()
    @ObservedObject private var documentViewModel = DocumentViewModel()
    //var machine: Machine
    var showMachineFile: Bool = false
    var showCircuitDiagram: Bool = false
    var showOperationManual: Bool = false
    @State var recievingEmailAdress: String = "defaultmail@gmail.com"
    @State var showMailSheet: Bool = false
    @State var showContactPersonMailSheet: Bool = false
    @State var isPresentingWebsiteSheet: Bool = false
    @State var showFavoriteButton: Bool = true
    @State var documentURL: String = ""
    @State var result: Result<MFMailComposeResult, Error>? = nil
    init(){
        UITableView.appearance().backgroundColor = .clear
        //self.machine = machine
    }
var body: some View{
    
    ZStack{
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
        VStack{
            Form {
                VStack(alignment: .leading){
                    HStack{
                        Text("Typ: ")
                            .fontWeight(.semibold)
                        Text(environment.currentMachine.type)
                    }
                    HStack{
                        Text("Bestellnummer: ")
                            .fontWeight(.semibold)
                        Text(environment.currentMachine.orderNumber)
                    }
                    HStack{
                        Text("Liefertermin: ")
                            .fontWeight(.semibold)
                        Text(environment.currentMachine.deliveryDate)
                    }
                    HStack{
                        Text("Installationsende: ")
                            .fontWeight(.semibold)
                        Text(environment.currentMachine.installationEnd)
                    }
                    HStack{
                        Text("Garantiebeginn: ")
                            .fontWeight(.semibold)
                        Text(environment.currentMachine.warrantyBegin)
                    }
                    HStack{
                        Text("Garantieende: ")
                            .fontWeight(.semibold)
                        Text(environment.currentMachine.warrantyEnd)
                    }
                    HStack{
                        Text("Kunde: ")
                            .fontWeight(.semibold)
                        Text(customerViewModel.currentMachineCustomer.description1)
                    }
                    
                    
                    
                }
                //ROLLE: alle Hersteller
                if(environment.currentUser.role == "Hersteller" || environment.currentUser.role == "Hersteller Admin"){
                    Section(header: Text("Maschinendateien").foregroundColor(Color.white), footer: Text("Einen der Menüpunkte anklicken um jeweilige Datei anzeigen zu lassen").foregroundColor(Color.white)){
                        ForEach((0..<documentViewModel.documentList.count), id: \.self){document in
                            NavigationLink(destination: SwiftUIWebView(url: URL(string: documentViewModel.documentList[document].URL))){
                                Text(documentViewModel.documentList[document].documentType)
                            }
                        }
                    }
                }
                
                if(environment.currentUser.role == "Hersteller" || environment.currentUser.role == "Hersteller Admin"){
                    if(!customerViewModel.customerContactpersons.isEmpty){
                        Section(header: Text("Ansprechpartner").foregroundColor(Color.white), footer: Text("Rufen Sie die Ansprechpatner des Kunden an oder schreiben Sie eine EMail.").foregroundColor(Color.white)){
                            ForEach((0..<customerViewModel.customerContactpersons.count), id: \.self){contactperson in
                                VStack{
                                    Text("\(customerViewModel.customerContactpersons[contactperson].firstName) \(customerViewModel.customerContactpersons[contactperson].lastName)")
                                    HStack{
                                        Button{
                                            recievingEmailAdress = customerViewModel.customerContactpersons[contactperson].email
                                            showContactPersonMailSheet = true
                                            
                                        }label: {
                                            HStack{
                                                Text("Email schreiben")
                                                Image(systemName: "envelope.fill")
                                                }
                                            }.buttonStyle(BorderlessButtonStyle())
                                        
                                        Spacer()
                                        Button{
                                                if let url = URL(string: "tel://\(customerViewModel.customerContactpersons[contactperson].phonenumber1)") {
                                                    UIApplication.shared.open(url)
                                             }
                                        }
                                        label: {
                                            HStack{
                                                Text("Anrufen")
                                                Image(systemName: "phone.circle.fill")
                                                    .foregroundColor(.green)
                                            }
                                        }.buttonStyle(BorderlessButtonStyle())
                                    }//TODO: Change that recieving Email is correct, because showContactpersonMailSheet gets activated for all sheets
                                    .sheet(isPresented: $showContactPersonMailSheet){
                                        MailView(result: self.$result, Subject: "Anfrage", MsgBody: "Hallo, ich hätte eine Frage:",RecievingEMailAdress: self.$recievingEmailAdress )
                                        }
                                    }
                                }
                        }
                    }
                }
                if(environment.currentUser.role == "Kunde" || environment.currentUser.role == "Hersteller Admin"){
                    Section(header: Text("Kundenservice").foregroundColor(Color.white), footer: Text("Kontaktieren Sie bei Fragen oder Problemen unseren Kundenservice.").foregroundColor(Color.white)){
                        NavigationLink(destination: SpareView()){
                            Text("Ersatzteile bestellen")
                            }
                        Button{
                            recievingEmailAdress = "service@krause.de"
                            showMailSheet = true
                        }label: {
                            Text("Krause Service E- Mail")
                        }.sheet(isPresented: $showMailSheet){
                            MailView(result: self.$result, Subject: "Service Anfrage", MsgBody: "Hallo, ich hätte eine Frage:",RecievingEMailAdress: self.$recievingEmailAdress)
                        }
                        Button{
                            recievingEmailAdress = "ersatzteile@krause.de"
                            showMailSheet = true
                        }label: {
                            Text("Krause Ersatzteile E- Mail")
                        }.sheet(isPresented: $showMailSheet){
                            MailView(result: self.$result, Subject: "Erstzteilbestellung", MsgBody: "Hallo, ich hätte eine Frage:",RecievingEMailAdress: self.$recievingEmailAdress)
                            }
                        }
                    }
                if(environment.currentUser.role == "Hersteller" || environment.currentUser.role == "Hersteller Admin"){
                    Section(header: Text("Bauzustand").foregroundColor(Color.white), footer: Text("Die abgehakten Bauzustände sind bereits erreicht. Wenn Sie einen neuen Bauzustand erreicht haben markieren Sie den Bauzustand als erledigt.").foregroundColor(Color.white)){
                        Group{
                            NavigationLink(destination: ReportStatus()){
                                Text("Bauzustand melden")
                            }
                        
                            }
                    
                        }
                    }
                
            }.navigationTitle(environment.currentMachine.id ?? "")
                .onAppear {
                    customerViewModel.setCurrentMachineCustomer(customerID: environment.currentMachine.customerID)
                    customerViewModel.getAllContactPersonsByCustomerID(customerID: environment.currentMachine.customerID)
                    documentViewModel.getAllDocumentsByMachineID(machineID: environment.currentMachine.id ?? "")
                }
            if(!environment.currentUser.savedMachines.contains(environment.currentMachine.id ?? "") && showFavoriteButton == true){
                    Button{
                        showFavoriteButton = false
                        let db = Firestore.firestore()
                        db.collection("Users").document(environment.currentUser.id ?? "").updateData([
                    
                            "Gespeicherte Maschinen": FieldValue.arrayUnion([environment.currentMachine.id ?? ""])
                        ])
                    }label: {
                        VStack{
                            Image(systemName: "star.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color.blue)
                            Text("Zu Favoriten hinzufügen")
                                .foregroundColor(Color.blue)
                        }
                    }
                }
            }
        }
    }
}

