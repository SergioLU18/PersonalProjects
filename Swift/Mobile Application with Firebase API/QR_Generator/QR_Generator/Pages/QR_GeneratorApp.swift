//
//  QR_GeneratorApp.swift
//  QR_Generator
//
//  Created by Alumno on 18/10/21.
//

import SwiftUI
import Firebase

@main
struct QR_GeneratorApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HelperView()
        }
    }
}
