//
//  Card.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 13/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation

struct setGameCard {
    let attributes: [Int]
    init(shape: Int, fill: Int, color: Int, number: Int){
        attributes = [shape, fill, color, number]
    }
}

extension setGameCard: Equatable {
    static func == (lhs: setGameCard, rhs: setGameCard) -> Bool {
        for index in 0...3 {
            if lhs.attributes[index] != rhs.attributes[index] {
                return false
            }
        }
        return true
    }
}
