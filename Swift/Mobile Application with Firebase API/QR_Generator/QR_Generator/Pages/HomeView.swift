//
//  HomeView.swift
//  QR_Generator
//
//  Created by Alumno on 01/11/21.
//

import SwiftUI

struct HomeView: View {
    
    var username: String = "Hambre Cero"
    
    var body: some View {
            TabView {
                DonationView()
                    .tabItem {
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
//                        Label("Donar", systemImage: "takeoutbag.and.cup.and.straw.fill")
                    }
                GamesView()
                    .tabItem {
                        Image(systemName: "gamecontroller.fill")
//                        Label("Juegos", systemImage: "gamecontroller.fill")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "person.fill")
//                        Label("Perfil", systemImage: "person.fill")
                    }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
