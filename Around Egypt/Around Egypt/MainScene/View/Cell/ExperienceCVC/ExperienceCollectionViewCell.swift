//
//  ExperienceCollectionViewCell.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import UIKit

class ExperienceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likeButton: RadioButton!
    @IBOutlet weak var experienceTitleLabel: UILabel!
    
    var likesButtonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func liekButtonTapped(_ sender: RadioButton) {
        likesButtonTapped?()
    }
    
}

extension ExperienceCollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "ExperienceCollectionViewCell", bundle: nil)
    }
    static let identifier = "ExperienceCollectionViewCell"
}
