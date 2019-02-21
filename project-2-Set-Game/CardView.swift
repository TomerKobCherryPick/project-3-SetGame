//
//  CardViewController.swift
//  SetGame
//
//  Created by Tomer Kobrinsky on 21/02/2019.
//  Copyright © 2019 Tomer Kobrinsky. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardButton: UIButton!
    weak var delegate: CardDelegate?
    var index: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        Bundle.main.loadNibNamed("cardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cardButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cardButton.layer.cornerRadius = 6.0
    }
    @IBAction func touchCard(_ sender: UIButton) {
        delegate?.updateViewForCard(button: sender, index: index!)
    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
