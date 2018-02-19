//
//  DialogTableViewCell.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 15/02/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit

class DialogTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String, message: String) {
    
        self.userImage.backgroundColor = .black
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
}
