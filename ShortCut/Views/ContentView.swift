//
//  ContentView.swift
//  ShortCut
//
//  Created by Bjane Küper on 20.12.21.
//

import SwiftUI


struct ContentView: View {
    @State var textContent: String = ""
    
    var body: some View {
        NavigationView{
            NavigationLink(destination: LoginView()){
                VStack(alignment: .center){
                    Text("ShortCut")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 0.59, saturation: 1.0, brightness: 1.0))
                    LottieView(fileName: "QRCodeAnimation",isLooping: false)
                        .frame(width: 200, height: 200)
                    
                }.padding(EdgeInsets(top: 100, leading: 100, bottom: 250, trailing: 100))
                    
            }.navigationBarBackButtonHidden(true)
        
    }
        
}
}

struct MyButton: View{
    var label: String
    var body: some View {
        Button{
            
        } label: {
            Text(label)
                .padding(7)
                .foregroundColor(.white)
        }
        .background(Color(hue: 0.59, saturation: 1.0, brightness: 1.0))
        .cornerRadius(12)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
