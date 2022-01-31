//
//  CustomerView.swift
//  ShortCut
//
//  Created by Bjarne Küper on 19.01.22.
//

import SwiftUI


struct CustomerListElement: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //@EnvironmentObject var customerInfo: CustomerInformation
    @EnvironmentObject var customerInfo: ViewModel
    var customer: Customer
    init(customer: Customer){
        self.customer = customer
    }
    var body: some View {
        
        HStack{
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading){
                Text(customer.name)
                    .font(.headline)
                    
                Text(customer.address)
                    .font(.subheadline)
                
                Text(customer.email)
                    .font(.subheadline)
                
                
            }
        }.onTapGesture{
            customerInfo.customerId = customer.id
            customerInfo.name = customer.name
            customerInfo.address = customer.address
            customerInfo.email = customer.email
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
struct CustomerList: View {
    //@ObservedObject var model = ViewModel()
    @EnvironmentObject var model: ViewModel
    @State var name = ""
    @State var address = ""
    @State var email = ""
    @State var phoneNumber = ""
    var body: some View {
        
        VStack {
            Text("Liste aller Kunden")
                .font(.largeTitle)
                .fontWeight(.semibold)
            List(0..<model.customerList.count, id: \.self){
                customer in
                CustomerListElement(customer: model.customerList[customer])
                
            }
            VStack(alignment: .leading, spacing: 8.0){
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Adresse", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Phonenumber", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding()
            Button(action: {
                model.addCustomer(name: name, address: address, email: email, phoneNumber: phoneNumber)
                
                name = ""
                address = ""
                email = ""
                phoneNumber = ""
                
                
            }, label: {
                Text("Kunden hinzufügen")
                    .font(.headline)
                    .fontWeight(.bold)
            })
        }
    }
    init(){
        //model.getAllCustomers()
        
    }
}/*
class CustomerInformation: ObservableObject{
    @Published var id: String = ""
    @Published var name: String = "Kunde hinzufügen"
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
}*/


/*struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        //CustomerListElement()
        //CustomerList()
    }
}*/
