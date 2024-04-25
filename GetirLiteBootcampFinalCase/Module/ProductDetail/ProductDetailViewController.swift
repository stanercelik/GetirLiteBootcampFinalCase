//
//  ProductDetailViewController.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 25.04.2024.
//

import UIKit

protocol ProductDetailProtocol {
    func configure()
    func configureButtons()
    func updateBasketView()
    func setupCountLabel()
}
protocol ProductDetailDelegate {
    
    func activateBasketView()
    func deactivateBasketView()
    
    func addHorizontalItem(add : HorizontalProduct)
    func addVerticalItem(add : VerticalProduct)
    
    func deleteHorizontalItem(product: HorizontalProduct)
    func deleteVerticalItem(product: VerticalProduct)
    
}

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var dissmisButton: UIButton!
    @IBOutlet weak var basketView: UIView!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countContainerView: UIView!
    
    var horizontalProduct : HorizontalProduct?
    var verticalProduct : VerticalProduct?
    
    var count = 0
    
    var delegate : ProductDetailDelegate?
    
    var basket = Basket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    @IBAction func dissmissButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if horizontalProduct != nil{
            self.basket.horizontalProduct?.append(horizontalProduct!)
            delegate?.addHorizontalItem(add: self.horizontalProduct!)
            delegate?.activateBasketView()
        }else if verticalProduct != nil {
            self.basket.verticalProduct?.append(verticalProduct! )
            delegate?.addVerticalItem(add: verticalProduct!)
            delegate?.activateBasketView()
            
        }
        updateBasketView()
        
        self.basketView.isHidden = false
        self.countContainerView.isHidden = false
        self.addButton.isHidden = false
        self.deleteButton.isHidden = false

        self.count += 1
        countLabel.text = String(count)
    }
    
    @IBAction func addtoCartButtonClicked(_ sender: Any) {
        if count > 0 {
            count -= 1
            self.countLabel.text = String(count)
            
            if let horizontalProduct = self.horizontalProduct {
                delegate?.deleteHorizontalItem(product: horizontalProduct)
                
                let index = self.basket.horizontalProduct?.lastIndex(where: { $0.id == horizontalProduct.id })
                if let index = index {
                    self.basket.horizontalProduct?.remove(at: index)
                }
                
            }
            if let verticalProduct = self.verticalProduct {
                delegate?.deleteVerticalItem(product: verticalProduct)
                
                let index = self.basket.verticalProduct?.lastIndex(where: { $0.id == verticalProduct.id })
                if let index = index {
                    self.basket.verticalProduct?.remove(at: index)
                }
            }
            self.updateBasketView()
                
        }else {
//            self.basketView.isHidden = true
//            delegate?.DeactivateBasketView()
        }

    }
}



extension ProductDetailViewController: ProductDetailProtocol{
    
    func setupCountLabel() {
        
        var number = self.count
        
        if let horizontalProduct = self.horizontalProduct {
            for product in self.basket.horizontalProduct ?? [] {
                if product.id == horizontalProduct.id{
                    number += 1
                }
            }
            self.countLabel.text = String(number)
        }
        if let verticalProduct = self.verticalProduct {
            for product in self.basket.verticalProduct ?? [] {
                if product.id == verticalProduct.id{
                    number += 1
                }
            }
            self.countLabel.text = String(number)
        }
        
    }
    
    func updateBasketView() {
        var price = Double(basketLabel.text ?? "0.0") ?? 0.0
        
        for horizontalItem in basket.horizontalProduct ?? [] {
            price += Double(horizontalItem.price ?? 0)
        }
        for verticalItem in basket.verticalProduct ?? [] {
            price += Double(verticalItem.price ?? 0)
        }
        self.basketLabel.text = String("₺ \(price)")
        
        if self.basketLabel.text == "0"{
            self.basketView.isHidden = true
        }else {
            self.basketView.isHidden = false
        }

    }
    
    func configureButtons() {
        
        // TODO: butonlar doğru çalışmıyor -->  containerView.removeFromSuperview() çözüm yöntermi bu
        self.countContainerView.isHidden = false
        self.addButton.isHidden = false
        self.deleteButton.isHidden = false
        self.addToCartButton.isHidden = true
    }
    
    
    func configure() {
        
        self.basketView.isHidden = true
        basketView.layer.cornerRadius = 10
        basketImageView.layer.cornerRadius = 10
        
        if self.horizontalProduct != nil {
            if horizontalProduct?.imageURL != nil {
                productImageView.load(url: URL(string: horizontalProduct?.imageURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")! )
            } else {
                productImageView.load(url: URL(string: horizontalProduct?.squareThumbnailURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")! )
            }
            self.priceLabel.text = horizontalProduct?.priceText
            self.nameLabel.text = horizontalProduct?.name
            self.attributeLabel.text = horizontalProduct?.shortDescription ?? ""
            
        } else if self.verticalProduct != nil{
            if verticalProduct?.imageURL != nil {
                productImageView.load(url: URL(string: verticalProduct?.imageURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")! )
            } else {
                productImageView.load(url: URL(string: verticalProduct?.thumbnailURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")! )
            }
            self.priceLabel.text = verticalProduct?.priceText
            self.nameLabel.text = verticalProduct?.name
            self.attributeLabel.text = verticalProduct?.shortDescription ?? ""
        } else {
            
        }
    }
    
    
    
}
