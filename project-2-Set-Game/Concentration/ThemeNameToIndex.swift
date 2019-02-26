//
//  ThemeNameToIndex.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 26/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation
struct ThemeNameToIndex {
    init() {
}
    subscript(index: Int) -> String? {
        switch index {
        case 0: return "Halloween"
        case 1: return "Sports"
        case 2: return "Vehicles"
        case 3: return "Fruits"
        case 4: return "Carbohydrates"
        case 5: return "Animals"
        default: return nil
        }
    }
    subscript(index: String) -> Int? {
        switch index {
        case "Halloween": return 0
        case "Sports": return 1
        case "Vehicles": return 2
        case "Fruits": return 3
        case "Carbohydrates": return 4
        case "Animals": return 5
        default: return nil
        }
    }
}
