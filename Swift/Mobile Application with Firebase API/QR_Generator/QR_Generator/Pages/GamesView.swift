//
//  GamesView.swift
//  QR_Generator
//
//  Created by Alumno on 10/11/21.
//

import SwiftUI

struct GamesView: View {
    
    init() {
            //Use this if NavigationBarTitle is with displayMode = .inline
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color("Primary-Purple")),
                                                                .font: UIFont(name: "Quicksand-Medium", size: 18)!]
        }
    
    @State var showGame: Bool = false
    @State private var showingAlert = false
    
    @AppStorage("localDonations") var localDonations = 0
    
    var gameList: GameList = GameList.games
    
    var body: some View {
        NavigationView{
        VStack{
            HStack {
                Text("Desbloqueados")
                    .foregroundColor(Color("Secondary-MediumPurple"))
                Spacer()
            }
            ForEach(gameList.Games) { game in
                if(game.donations <= localDonations) {
                    NavigationLink(destination: GameMenuView(game: game).navigationBarHidden(true), label: {
                        Image("\(game.code)-mini")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .frame(width: 60,height: 60)
                            .padding(.vertical,15)
                            
                        Spacer()
                        Text(game.title)
                        Spacer()
                    })
                        .padding(.horizontal,15)
                        .background(Color("Secondary-Blue"))
                        .foregroundColor(Color("Text-Black"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .font(.Quicksand(style: "Bold", size: 22))
                        .shadow(color: Color("Secondary-MediumPurple"), radius: 0, x: 2, y: 2)
                }
            }
            
            HStack {
                Text("Bloqueados")
                    .foregroundColor(Color("Secondary-MediumPurple"))
                Spacer()
            }
            .padding(.top,20)
            
            ForEach(gameList.Games) { game in
                if(game.donations > localDonations) {
                    Button(action: {
                        showingAlert = true
                    }, label: {
                        Image("\(game.code)-mini")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .frame(width: 60,height: 60)
                            .padding(.vertical,15)
                            
                        Spacer()
                        Text(game.title)
                        Spacer()
                    })
                        .alert("Dona más para acceder a este juego", isPresented: $showingAlert, actions: {})
                        .padding(.horizontal,15)
                        .background(Color("Secondary-DarkPurple"))
                        .foregroundColor(Color("Text-Black"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .font(.Quicksand(style: "Bold", size: 22))
                        .shadow(color: Color("Secondary-LightPurple"), radius: 0, x: 2, y: 2)
                }
            }
            
//            Spacer()
            
        }
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showGame, onDismiss: nil) {
            GameViewController()
        }
        .padding(.horizontal,50)
        .navigationBarTitle(Text("Juegos"), displayMode: .inline)
        }
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}

