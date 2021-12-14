//
//  GameList.swift
//  QR_Generator
//
//  Created by Carlos Remes on 18/11/21.
//

import SwiftUI

struct Game: Identifiable {
    var id: Int
    var title: String
    var path: AnyView
    var code: String
    var donations: Int
}

extension Game {
    static let dummy = Game(id: 0, title: "Ghost Attack", path: AnyView(GameViewController()), code: "GhostAttack", donations: 0)
}

struct GameList {
    var Games: [Game]
}

extension GameList {
    static let games = GameList(Games: [
        Game(id: 0, title: "Ghost Attack", path: AnyView(GameViewController()), code: "GhostAttack", donations: 0),
        Game(id: 1, title: "Baller Shoot", path: AnyView(BallGameView()), code: "BallerShoot", donations: 50),
        Game(id: 2, title: "Flappy Bro", path: AnyView(FlappyGameView()), code: "FlappyBro", donations: 100) ,
        Game(id: 3, title: "Pong", path: AnyView(PongGameView()), code: "Pong", donations: 150) ,
    ])
}
