//
//  BoardOfCardsDelegate.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 21/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation
import UIKit
protocol BoardOfCardsDelegate: class {
    func updateViewForCard(button: UIButton, index: Int)
    func touchedCard(cardButton: UIButton, index: Int)
}
