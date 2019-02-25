//
//  BoardOfCardsController.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 21/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import UIKit

class BoardOfCardsView: UIView {
    private(set) var cardButtons = [UIButton]()
    weak var delegate: BoardOfCardsDelegate?
    
    @IBOutlet var contentView: UIView!
    lazy private var grid = Grid(layout: Grid.Layout.aspectRatio(0.5), frame: self.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        Bundle.main.loadNibNamed("BoardOfCardsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func clearViews() {
        cardButtons = []
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        grid.cellCount = 0
    }
    func updateFrame() {
        grid.frame = self.bounds
        for index in contentView.subviews.indices {
            contentView.subviews[index].frame = grid[index]!
        }
    }
    
     func addCardToView() {
        grid.cellCount += 1
        let currentIndex = grid.cellCount - 1
        let cardView = CardView(frame: grid[currentIndex]!)
        cardView.delegate = self
        cardView.index = currentIndex
        cardButtons.append(cardView.cardButton)
        delegate?.updateViewForCard(button: cardView.cardButton, index: cardButtons.count - 1)
        contentView.addSubview(cardView)
        for index in contentView.subviews.indices {
            contentView.subviews[index].frame = grid[index]!
        }
    }
    
}
extension BoardOfCardsView: CardDelegate{
    func updateViewForCard(button: UIButton, index: Int) {
        delegate?.touchedCard(cardButton: button, index: index)
    }
    
    
}
