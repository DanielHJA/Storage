//
//  PasswordTableViewCell.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 2016-10-20.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
