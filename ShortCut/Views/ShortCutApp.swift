//
//  ShortCutApp.swift
//  ShortCut
//
//  Created by Bjarne Küper on 20.12.21.
//

import SwiftUI
import Firebase
@main
struct ShortCutApp: App {
    @StateObject var model = ViewModel()
    init(){
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
