//
//  VerticalCollectionViewCell.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 24.04.2024.
//

import UIKit

// MARK: - VerticalCollectionViewCellDelegate Protocol
protocol VerticalCollectionViewCellDelegate {
    
    func activateBasketView()
    func deactivateBasketView()
    
    func addVerticalProduct(product : VerticalProduct)
    func deleteVerticalProduct(product : VerticalProduct)
}

class VerticalCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var verticalProduct : VerticalProduct?
    var delegate : VerticalCollectionViewCellDelegate?
    var count = 0

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    // MARK: - Actions
    @IBAction func addButtonClicked(_ sender: Any) {
        self.countView.isHidden = false
        self.deleteButton.isHidden = false
        self.count += 1
        countLabel.text = String(self.count)
        delegate?.addVerticalProduct(product: self.verticalProduct!)
        delegate?.activateBasketView()
    }

    @IBAction func deleteButtonClicked(_ sender: Any) {
        if self.count < 1 {
            self.count -= 1
            self.countView.isHidden = true
            self.deleteButton.isHidden = true
            delegate?.deactivateBasketView()

        } else {
            self.count -= 1
            countLabel.text = String(self.count)
            delegate?.deleteVerticalProduct(product: self.verticalProduct!)
            if self.count == 0{
                self.countView.isHidden = true
                self.deleteButton.isHidden = true
            }
        }
        
    }

}

extension VerticalCollectionViewCell {
    
    func configure() {
        countView.isHidden = true
        deleteButton.isHidden = true
        
        addButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        addButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowRadius = 0.0
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius = 3.0
        
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 15
        imageView.layer.borderColor = CGColor(red: 0.749, green: 0.749, blue: 0.749, alpha: 1.0)
    }
}

