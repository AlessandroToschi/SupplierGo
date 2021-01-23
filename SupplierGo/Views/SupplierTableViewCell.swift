//
//  SupplierTableViewCell.swift
//  SupplierGo
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import UIKit

class SupplierTableViewCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView?
    @IBOutlet var fullnameLabel: UILabel?
    @IBOutlet var companyLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
