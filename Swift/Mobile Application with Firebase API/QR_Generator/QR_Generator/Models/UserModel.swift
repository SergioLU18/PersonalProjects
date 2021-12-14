//
//  UserModel.swift
//  QR_Generator
//
//  Created by Alumno on 17/11/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserModel: ObservableObject {
    
    @AppStorage("localID") var localID: String = ""
    @AppStorage("localUser") var localUser: String = ""
    @AppStorage("localPassword") var localPassword: String = ""
    @AppStorage("localDonations") var localDonations: Int = 0
    @AppStorage("localRanking") var localRanking: Int = 0
    @AppStorage("localAdmin") var localAdmin: Bool = false
    @AppStorage("localEmail") var localEmail: String = ""
    @AppStorage("localIcon") var localIcon: String = ""
    
    
    // SCORES
    @AppStorage("flappyScore") var flappyScore: Int = 0
    @AppStorage("ghostScore") var ghostScore: Int = 0
    @AppStorage("ballerScore") var ballerScore: Int = 0
    
    var found: Bool = true
    let auth = Auth.auth()
    
    private let db = Firestore.firestore()
    
    func fetchUser(email: String, password: String, handler: @escaping (_ found: Bool) -> () )  {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.found = false
                return
            }
            print("Correct credentials")
            self.db.collection("User").document(self.auth.currentUser!.uid).getDocument() {
                (document, err) in
                if let document = document, document.exists {
                    self.localID = document.documentID
                    self.localUser = document["user_name"] as! String
                    self.localPassword = password
                    self.localDonations = document["user_donations"] as! Int
                    self.localRanking = document["user_ranking"] as! Int
                    self.localAdmin = document["is_admin"] as! Bool
                    self.localIcon = document["icon"] as! String
                    self.localEmail = document["email"] as! String
                    self.fetchScores(game: "FlappyBro")
                    self.fetchScores(game: "GhostAttack")
                    self.fetchScores(game: "BallerShoot")
                    self.found = true
                }
                else {
                    self.found = false
                }
                handler(self.found)
            }
            
        }
    }
    
    private func fetchScores(game: String) {
        db.collection(game).document(localID).getDocument { (document, error) in
            if let document = document, document.exists {
                if(game == "FlappyBro") {
                    self.flappyScore = document["score"] as! Int
                }
                if(game == "GhostAttack") {
                    self.ghostScore = document["score"] as! Int
                }
                if(game == "BallerShoot") {
                    self.ballerScore = document["score"] as! Int
                }
            }
            else {
                print(self.localID)
                self.db.collection(game).document(self.localID).setData(["score": 0])
                print("Se creo score! :D")
            }
        }
    }
}
