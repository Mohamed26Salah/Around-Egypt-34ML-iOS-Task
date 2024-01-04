//
//  ExperienceTableViewCell.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var viewsCounter: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    
    var likesButtonTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likesButtonTapped(_ sender: UIButton) {
        likesButtonTapped?()
    }
    
}
extension ExperienceTableViewCell {
    static func nib() -> UINib {
        return UINib(nibName: "ExperienceTableViewCell", bundle: nil)
    }
    static let identifier = "ExperienceTableViewCell"
}
