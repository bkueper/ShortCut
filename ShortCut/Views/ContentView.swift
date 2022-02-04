//
//  ContentView.swift
//  ShortCut
//
//  Created by Bjane Küper on 20.12.21.
//

import SwiftUI


struct ContentView: View {

    
    var body: some View {
        NavigationView{
                NavigationLink(destination: LoginView()){
                   VStack(alignment: .center){
                        Text("ShortCut")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.blue))
                        LottieView(fileName: "QRCodeAnimation",isLooping: false)
                            .frame(width: 200, height: 200)
                            .colorInvert()

                    }.padding(EdgeInsets(top: 300, leading: 120, bottom: 300, trailing: 120))
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea())
                }.navigationBarBackButtonHidden(true)
                .navigationTitle("")
                    .navigationBarHidden(true)
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
