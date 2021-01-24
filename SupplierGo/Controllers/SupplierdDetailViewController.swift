//
//  SupplierdDetailViewController.swift
//  SupplierGo
//
//  Created by Alessandro Toschi on 24/01/2021.
//

import UIKit
import SupplierGoKit

class SupplierdDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    var dateFormatter: DateFormatter!
    var supplier: Supplier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        if let supplier = self.supplier{
            self.nameLabel.text = supplier.fullname
            self.companyLabel.text = supplier.company
            self.creationDateLabel.text = self.dateFormatter.string(from: supplier.creationDate)
            self.phoneLabel.text = supplier.phone
            self.mailLabel.text = supplier.email.lowercased()
            
            if let avatarData = supplier.avatar.data, let avatarImage = UIImage(data: avatarData){
                self.avatarImageView.image = avatarImage
                self.avatarImageView.layer.cornerRadius = 15.0
            }
        }
    }
}
