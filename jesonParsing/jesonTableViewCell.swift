//
//  jesonTableViewCell.swift
//  jesonParsing
//
//  Created by Abhay Kmar on 01/05/22.
//

import UIKit

class jesonTableViewCell: UITableViewCell {

    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userGender: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
