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
    @StateObject var environment = EnvironmentHelper()
    init(){
        FirebaseApp.configure()
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(environment)
        }
    }
}
