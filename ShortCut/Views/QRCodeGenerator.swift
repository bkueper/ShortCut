//
//  QRCodeGenerator.swift
//  ShortCut
//
//  Created by Bjarne Küper on 11.02.22.
//
import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var url: String = ""
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2398733385, green: 0, blue: 0.7439433396, alpha: 1)), Color(#colorLiteral(red: 0.1026695753, green: 0, blue: 0.3184194925, alpha: 1))]), startPoint: .topLeading,endPoint: .bottom).ignoresSafeArea()
            VStack{
                Text("Geben Sie die Maschinennummer ein")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                TextField("Maschinennummer", text: $url)
                    .padding()
                    .background()
                    .cornerRadius(8)
                    .shadow(color: Color.black, radius: 3, x: 5, y: 2)
                Image(uiImage: generateQRCodeImage(url))
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 300, height: 300)
                Text("Machen Sie einen Screenshot vom QR- Code sobald die gewünschte Maschinennummer eingegeben ist.")
                    .font(.body)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            }
        }
    }
    func generateQRCodeImage(_ url: String) -> UIImage{
        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage{
            if let qrCodeImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent){
                return UIImage(cgImage: qrCodeImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
    }
}

struct QRCodeGenerator_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeGenerator()
    }
}
