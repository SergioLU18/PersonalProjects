//
//  User.swift
//  QR_Generator
//
//  Created by Alumno on 17/11/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    
    @DocumentID var id: String?
    var user_name: String
    var group_id: String
    var user_donations: Int
    var user_ranking: Int
    var is_admin: Bool
    var email: String
    var icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_name
        case group_id
        case user_donations
        case user_ranking
        case is_admin
        case email
        case icon
    }
}

extension User {
    
    static let dummy =  User(id: "000000", user_name: "user", group_id: "tec", user_donations: 1, user_ranking: 2, is_admin: false, email: "dummy@dummy.com", icon: "player")
    
}
