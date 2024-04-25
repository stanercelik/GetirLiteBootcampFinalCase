//
//  BasketTableViewCell.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 25.04.2024.
//

import UIKit

protocol BasketTableViewProtocol {
    func configureButtons()
}

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var addbutton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
    }
    
    
}

extension BasketTableViewCell: BasketTableViewProtocol{
    func configureButtons() {
        
    }
    
    
}


