//
//  Score.swift
//  QR_Generator
//
//  Created by Alumno on 24/11/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Score: Identifiable, Codable {
    
    @DocumentID var id: String?
    var name: String
    var score: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case score
    }
}
