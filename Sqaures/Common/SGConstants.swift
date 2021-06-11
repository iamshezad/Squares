//
//  SGConstants.swift
//  Sqaures
//
//  Created by Shezad Ahamed on 03/06/21.
//

import UIKit

struct SGStoryboards {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    static let game = UIStoryboard(name: "Game", bundle: nil)
}

//Square movement directions
enum GameDirection{
    case up
    case down
    case left
    case right
    case idle
}

//Game state
enum GameState{
    case playing
    case question
    case loading
    case memorize
    case over
    case won
}

//Game model
struct Game{
    var value: Int?
    var index: Int?
}
