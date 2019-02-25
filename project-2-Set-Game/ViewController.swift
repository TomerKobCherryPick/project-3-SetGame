//
//  ViewController.swift
//  project-2-Set-Game
//
//  Created by Tomer Kobrinsky on 12/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let intToShapeMap = [0: "▲", 1: "●", 2: "■"]
    private let intToColorMap = [0: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) , 1: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) , 2: #colorLiteral(red: 0.6679978967, green: 0.4751212597, blue: 0.2586010993, alpha: 1)]
    private let intToFillMap = [0: Fill.stripe, 1: Fill.filled, 2: Fill.outlined]
    private lazy var game = SetGame()
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var dealthreeCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cheatButton: UIButton!
    @IBOutlet weak var iphoneScoreLabel: UILabel!
    @IBOutlet weak var whoWonLabel: UILabel!
    @IBOutlet weak var cardsView: BoardOfCardsView!
    @IBOutlet weak var contentView: UIView! {
        didSet {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDealThreeMoreCards))
            swipeGesture.direction = .down
            contentView.addGestureRecognizer(swipeGesture)
            
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateReshuffle))
            contentView.addGestureRecognizer(rotationGesture)
        }
    }
    var opponentState: String {
        get {
            return game.opponentState.stateToEmoji()
        } set(newValue) {
            iphoneScoreLabel.text = "\(newValue) iphone's Score: \(game.opponentScore)"
        }
    }
    private var whoWonString: String {
        return game.score == game.opponentScore ? "It's a tie 🤨" :
            game.score > game.opponentScore ? "You Won 😃" : "You Lost 😩"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        cardsView.delegate = self
        dealthreeCardsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cheatButton.titleLabel?.adjustsFontSizeToFitWidth = true
        scoreLabel.adjustsFontSizeToFitWidth = true
        iphoneScoreLabel.adjustsFontSizeToFitWidth = true
        whoWonLabel.adjustsFontSizeToFitWidth = true
        whoWonLabel.text = ""
        iphoneScoreLabel.text = "\(opponentState) iphone's Score: \(game.opponentScore)"
        cardsView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    override func viewDidLayoutSubviews() {
        cardsView.updateFrame()
        if cardsView.cardButtons.count == 0 && !game.isGameOver {
            for _ in 0...11 {
                cardsView.addCardToView()
            }
        }
    }
    private func setTextInCard(button: UIButton, card: Card) {
        var shape = intToShapeMap[card.attributes[0]]!
        let color = intToColorMap[card.attributes[1]]!
        let fill = intToFillMap[card.attributes[2]]!
        for _ in 0..<card.attributes[3] {
            shape += intToShapeMap[card.attributes[0]]!
        }
        let attributedString = NSAttributedString(string: shape, attributes: Fill.convertToNSAttributedStringKeys(fillType: fill, color: color))
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
    
    @IBAction func touchNewGame(_ sender: Any) {
        game.resetGame()
        cardsView.clearViews()
        for _ in 0...11 {
            cardsView.addCardToView()
        }
        dealthreeCardsButton.setTitle("Deal 3 more Cards", for: UIControl.State.normal)
        cheatButton.setTitle("Cheat", for: UIControl.State.normal)
        whoWonLabel.text = ""
        scoreLabel.text = "Score: \(game.score)"
    }
    @IBAction func touchDealThreeMoreCards(_ sender: Any) {
        game.dealThreeMoreCards()
        if game.deck.count == 0 {
            dealthreeCardsButton.setTitle("", for: UIControl.State.normal)
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    @objc private func swipeDealThreeMoreCards(_ recognizer: UISwipeGestureRecognizer) {
        game.dealThreeMoreCards()
        if game.deck.count == 0 {
            dealthreeCardsButton.setTitle("", for: UIControl.State.normal)
        }
        scoreLabel.text = "Score: \(game.score)"
    }
    
    @objc private func rotateReshuffle(_ recognizer: UIRotationGestureRecognizer) {
        game.reshuffle()
        for index in cardsView.cardButtons.indices {
            updateViewForCard(button: cardsView.cardButtons[index], index: index)
        }
    }
    
    @IBAction func touchCheat(_ sender: Any) {
        updateViewFromModel()
        let possibleMatch =  game.checkIfThereIsAMatchOnBoard()
        if possibleMatch.isMatched {
            for index in possibleMatch.arrayOfMatchedCards!{
                cardsView.cardButtons[index].backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
            }
        }
    }
    private func updateViewFromModel(){
        scoreLabel.text = "Score: \(game.score)"
        for index in game.cardsOnBoard.indices {
            updateViewForCard(button: cardsView.cardButtons[index], index: index)
        }
    }
    
    private func clearViewForButton(button: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        let attributedString = NSAttributedString(string: "", attributes: [:])
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
}
extension ViewController: SetGameDelegate {
    func dealtCard(didDealt: Bool) {
        cardsView.addCardToView()
    }
    func replacedCard(card: Card, index: Int) {
        updateViewForCard(button: cardsView.cardButtons[index], index: index)
    }
    func gameOver() {
        whoWonLabel.text = "\(whoWonString)"
        cheatButton.setTitle("", for: UIControl.State.normal)
        dealthreeCardsButton.setTitle("", for: UIControl.State.normal)
    }
    func macthedIndicesIfExist(match: Array<Int>?) {
        if match != nil {
            for index in match! {
                cardsView.cardButtons[index].backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            }
            for button in cardsView.cardButtons {
                button.isEnabled = false
            }
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(selector), userInfo: nil, repeats: false)
        }
        
    }
    @objc private func selector() {
        updateViewFromModel()
        for button  in cardsView.cardButtons {
            button.isEnabled = true
        }
    }
    func setOpponentState(data: OpponentState) {
        opponentState = data.stateToEmoji()
    }
}

extension ViewController: BoardOfCardsDelegate {
    func updateViewForCard(button: UIButton, index:Int) {
        if index < game.cardsOnBoard.count {
            let card = game.cardsOnBoard[index]
            if !game.selectedCards.contains(card) {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.backgroundColor = game.selectedCards.count == 3 ?
                    game.selectedCardsMatched! ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    :#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.3732074058)
            }
            setTextInCard(button: button, card: game.cardsOnBoard[index])
        } else {
            clearViewForButton(button: button)
        }
    }
    func touchedCard(cardButton: UIButton, index: Int)  {
        game.selectCard(at: index)
        for currentIndex in cardsView.cardButtons.indices {
            updateViewForCard(button: cardsView.cardButtons[currentIndex], index: currentIndex)
        }
        scoreLabel.text = "Score: \(game.score)"
    }
}


