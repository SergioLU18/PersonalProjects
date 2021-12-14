//
//  GameLeaderboardView.swift
//  QR_Generator
//
//  Created by Carlos Remes on 18/11/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import simd

struct GameLeaderboardView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var scores: [Score] = [Score(id: "00", name: "", score: 0)]
    var cont: Int = 0
    
    var game: Game
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack{
                    ZStack {
                        Image("\(game.code)-medium")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .overlay(LinearGradient(gradient: Gradient(colors: [.clear, Color("Primary-Purple")]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(40)
                            .shadow(color: .gray, radius: 4, x: 0, y: 7)
                        
                        Text("\(game.title)")
                            .font(.Quicksand(style: "SemiBold", size: 45))
                            .foregroundColor(Color("Text-White"))
                    }
                    .padding(.bottom,20)
                    
                    .onAppear{
                        fetchLeaderboard()
                    }
                    
                    ForEach(scores.indices, id: \.self) { i in
                        HStack{
                            Text("\(i+1)")
                                .padding(.horizontal,20)
                                .font(.Quicksand(style: "SemiBold", size: 23))
                                .foregroundColor(Color("Primary-Purple"))
                            Text(scores[i].name)
                                .font(.Quicksand(style: "Medium", size: 20))
                                .foregroundColor(Color("Text-Black"))
                            Spacer()
                            VStack{
                                Text(String(scores[i].score))
                                    .font(.Quicksand(style: "Medium", size: 20))
                                    .foregroundColor(Color("Text-Black"))
                                Text("puntos")
                                    .font(.Quicksand(style: "Regular", size: 15))
                                    .foregroundColor(Color("Text-Black"))
                            }
                            .padding(.vertical,10)
                            .padding(.trailing,15)
                        }
                        .background(Color("Secondary-Blue"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal,25)
                    }
                    
                    
                    Spacer()
                }
            }
            HStack {
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.backward")
                            Text("atrás")
                        }
                        .foregroundColor(Color("Text-White"))
                        .font(.Quicksand(style: "SemiBold", size: 17))
                    })
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal,20)
            .padding(.top,10)
        }
    }
    private func fetchLeaderboard(){
        let db = Firestore.firestore()
        db.collection(game.code).order(by: "score", descending: true).addSnapshotListener { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("No Data")
                return
            }
            scores.removeAll()
            print(scores.count)
            for document in documents {
                db.collection("User").document(document.documentID).getDocument() { (doc, error) in
                    if let doc = doc, doc.exists {
                        let name = doc["user_name"] as! String
                        let score = document["score"] as! Int
                        let newScore = Score(id: document.documentID, name: name, score: score)
                        scores.append(newScore)
                    }
             
                }
            }
        }
    }
}

struct GameLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        GameLeaderboardView(game: Game.dummy)
    }
}

