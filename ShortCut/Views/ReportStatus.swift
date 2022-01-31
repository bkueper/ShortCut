//
//  ReportStatus.swift
//  ShortCut
//
//  Created by Bjarne Küper on 21.12.21.
//

import SwiftUI

struct ReportStatus: View {
    var body: some View {
        VStack {
            Text("Bauzustand melden")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Scannen Sie den QR- Code an der Maschine")
                .font(.subheadline)
            Spacer()
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .frame(width: 250, height: 250)
                .padding(10)
            HStack{
                Spacer()
                MyButton(label:"Zustand melden")

                Spacer()
                MyButton(label:"Abbrechen")
                Spacer()
            }
            Spacer()
        }
        .frame( height: UIScreen.screenHeight - 100)
    }
}

struct ReportStatus_Previews: PreviewProvider {
    static var previews: some View {
        ReportStatus()
    }
}
