//
//  UserTableViewCell.swift
//  FindMyDate
//
//  Created by Chris Dean on 2017-06-21.
//  Copyright © 2017 Chris Dean. All rights reserved.
//
import Firebase
import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var picHolder: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
