//
//  GameStartView.swift
//  QR_Generator
//
//  Created by Carlos Remes on 17/11/21.
//

import SwiftUI

struct GameMenuView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showGame: Bool = false
    
    var game: Game
    
    var body: some View {
        //Falta fondo de pantalla (relacionada con el juego)
        VStack{
            Text(game.title)
                .font(.Quicksand(style: "Bold", size: 45))
                .foregroundColor(Color("Primary-Purple"))
                .padding(.top, 150)
            Spacer()
            
            Button(action: {
                showGame.toggle()
                print("Play game")
            }, label: {
                HStack {
                    Spacer()
                    Text("Jugar")
                    Spacer()
                }
            })
                .fullScreenCover(isPresented: $showGame, onDismiss: nil) {
                    game.path
                }
                .buttonStyle(Primary())
                .padding(.horizontal,30)
            
            HStack {
                Button(action: {
                    //regresa a menu de juegos
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack{
                        Spacer()
                        Image(systemName: "chevron.backward")
                        Text("Regresar")
                        Spacer()
                    }
                })
                    .buttonStyle(Secondary())
                
                NavigationLink(destination: GameLeaderboardView(game: game).navigationBarHidden(true), label: {
                    Image(systemName: "crown.fill")
                })
                    .buttonStyle(Special())
                
            }
            .padding(.horizontal,30)
            .padding(.bottom,30)
        }
    }
}

struct GameMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GameMenuView(game: Game.dummy)
    }
}
