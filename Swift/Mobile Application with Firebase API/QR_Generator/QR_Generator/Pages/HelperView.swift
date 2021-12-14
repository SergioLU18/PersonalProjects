//
//  HelperView.swift
//  QR_Generator
//
//  Created by Alumno on 18/11/21.
//

import SwiftUI

struct HelperView: View {
    
    @AppStorage("logged") var logged: Bool = false
    
    var body: some View {
        if(logged) {
            HomeView()
        }
        else {
            SignInView(logged: $logged)
        }
    }
}

struct HelperView_Previews: PreviewProvider {
    static var previews: some View {
        HelperView()
    }
}
