//
//  AnotherUserTableViewCell.swift
//  VKApiTest
//
//  Created by Pavel Samsonov on 15/02/2018.
//  Copyright © 2018 Pavel Samsonov. All rights reserved.
//

import UIKit

class AnotherUserTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(text: String) {
        
        self.messageLabel.text = text
    }
}
