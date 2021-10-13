//
//  RatingContlor.swift
//  myPlaces
//
//  Created by Миша Вашкевич on 13.10.2021.
//

import UIKit

@IBDesignable class RatingContlor: UIStackView {

    //MARK properties
    var rating = 0 {
        didSet {
            updateButtonSelectedState()
        }
    }
    
    private var ratingButtons = [UIButton]()
    
    @IBInspectable var starSize: CGSize = CGSize(width:  44.0, height: 44.0) {
        didSet{
            setupBottuns()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupBottuns()
        }
    }
    
  // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBottuns()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupBottuns()
    }
    // MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton){
        
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        
        // calculate rating of selected button
        
         let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
        
    }
    
    // MARK: Private methods
    
    private func setupBottuns() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // load button images
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        for _ in 0..<starCount {
            // create botton
             
            let button = UIButton()
            
            // set button image
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            
            button.translatesAutoresizingMaskIntoConstraints = false // отключение автоматически сгенерированных Constant
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            // setup the button Action
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            // add button to the stackView
            addArrangedSubview(button)
            
            // add new button on the rating button array
            
            ratingButtons.append(button)
            
        }
        updateButtonSelectedState()
}

    private func updateButtonSelectedState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
}
