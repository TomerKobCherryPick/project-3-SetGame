//
//  Concentration.swift
//  Concentration
//
//  Created by Tomer Kobrinsky on 07/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import Foundation
class Concentration {
    
    private(set) var cards =  [ConcentrationCard]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var score = 0
    private var cardsThatHaveBeenSeen =  [Int: Bool]()
    private(set) var numberOfFlips = 0
    private var timeWhenGameStarted = Date.init()
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not in the cards")
        if !cards[index].isFaceUp {
            numberOfFlips += 1
        }
        if !cards[index].isMatched {
            if let IndexOfFacedUpCard = indexOfOneAndOnlyFaceUpCard,  IndexOfFacedUpCard != index {
                //check if cards  matched
                if cards[IndexOfFacedUpCard].identifier == cards[index].identifier {
                    cardsMatchedUpdate(index: index, IndexOfFacedUpCard: IndexOfFacedUpCard)
                } else {
                    cardsNotMatchedUpdate(index: index, IndexOfFacedUpCard:  IndexOfFacedUpCard)
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    private func cardsNotMatchedUpdate(index: Int, IndexOfFacedUpCard: Int) {
        if !hadBeenSeen(index: index){
            cardsThatHaveBeenSeen[cards[index].identifier] = true
        } else {
            degradeScore()
        }
        if !hadBeenSeen(index: IndexOfFacedUpCard){
            cardsThatHaveBeenSeen[cards[IndexOfFacedUpCard].identifier] = true
        } else {
            degradeScore()
        }
    }
    private func cardsMatchedUpdate(index: Int, IndexOfFacedUpCard: Int){
        score += Int(calulateFactor())
        cards[IndexOfFacedUpCard].isMatched = true
        cards[index].isMatched = true
    }
    private func calulateFactor() -> Double {
        let timePassedSinceGameStarted = Double (Date.init().timeIntervalSince(timeWhenGameStarted))
        return  (1000 / timePassedSinceGameStarted) + 30
    }
    
    private func hadBeenSeen (index: Int) -> Bool{
        if cardsThatHaveBeenSeen[cards[index].identifier] == nil {
            return false
        } else {
            return true
        }
    }
    
    private func degradeScore() {
            score -= 50
    }
    
    init(numberOfButtons: Int){
        assert(numberOfButtons > 0, "Concentration.init(at: \(numberOfButtons): you must have at least 1 button")
        let numberOfPairOfCards = (numberOfButtons + 1) / 2
        resetCards(numberOfgPairOfCards: numberOfPairOfCards)
    }
    
    func resetGame(numberOfButtons: Int){
        let numberOfgPairOfCards = (numberOfButtons + 1) / 2
        resetCards(numberOfgPairOfCards: numberOfgPairOfCards)
        indexOfOneAndOnlyFaceUpCard = nil
        score = 0
        cardsThatHaveBeenSeen =  [:]
        numberOfFlips = 0
        timeWhenGameStarted = Date.init()
    }
    private func resetCards(numberOfgPairOfCards: Int){
        cards = []
        for _ in 1...numberOfgPairOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        cards.shuffle()
    }
   
}
