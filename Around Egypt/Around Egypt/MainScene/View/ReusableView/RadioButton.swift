//
//  RadioButton.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 05/01/2024.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            updateButtonAppearance()
        }
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initButton()
    }
    
    func initButton() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.setTitle("", for: .normal)
        self.imageView?.contentMode = .scaleAspectFill // Add this line
        updateButtonAppearance()
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        isChecked = !isChecked
//        feedbackGenerator.impactOccurred()
        
        // Add a spring animation for a stronger effect
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0.9
        springAnimation.toValue = 1.0
        springAnimation.stiffness = 1500
        springAnimation.damping = 10
        springAnimation.mass = 0.5
        springAnimation.duration = springAnimation.settlingDuration
        
        self.layer.add(springAnimation, forKey: "springAnimation")
    }
    
    func updateButtonAppearance() {
        if isChecked {
            self.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.orangeHue), for: .normal)
        } else {
            self.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.orangeHue), for: .normal)
        }
    }
}
