//
//  BasketViewController.swift
//  GetirLiteBootcampFinalCase
//
//  Created by Taner Çelik on 25.04.2024.
//

import UIKit

protocol BasketViewControllerDelegate {
    func DeleteBasket()
}

class BasketViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var basketTableview: UITableView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var completeOrderButton: UIButton!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    var basket = Basket()
    
    var merged : [AnyObject] = []
    
    var totalPrice = 0.0
    
    var horizontalItems : [HorizontalProduct] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basketTableview.delegate = self
        basketTableview.dataSource = self
        basketTableview.rowHeight = 110
        basketTableview.register(UINib(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "basketTableViewCell")
        
        suggestedCollectionView.delegate = self
        suggestedCollectionView.dataSource = self
        suggestedCollectionView.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil) , forCellWithReuseIdentifier: "horizontalCell")
        suggestedCollectionView.reloadData()
        
        merged = (basket.horizontalProduct! as [AnyObject] ) + (basket.verticalProduct! as [AnyObject])
        
        print(self.horizontalItems)
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func trashButtonClicked(_ sender: Any) {
        self.basket.horizontalProduct = []
        self.basket.verticalProduct = []
        self.merged = []
        
        self.finalPriceLabel.text = "₺0,0"
        basketTableview.reloadData()
    }
    
    @IBAction func completeOrderButtonClicked(_ sender: Any) {
    }
    
    
}



// MARK: - TableView
extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.basket.horizontalProduct?.count ?? 0) + (self.basket.verticalProduct?.count ?? 0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketTableViewCell", for: indexPath) as! BasketTableViewCell
        
        if let item = merged[indexPath.row] as? HorizontalProduct {
            cell.nameLabel.text = item.name
            cell.priceLabel.text = item.priceText
            cell.attributeLabel.text = item.shortDescription
            self.totalPrice += (item.price ?? 0.0)
            if item.imageURL != nil {
                
                cell.imageView?.imageFromServerURL(urlString: item.imageURL!, PlaceHolderImage: UIImage.init(named: "Getir_Logo_Circle")!)
                
            }else{
                cell.productImageView?.imageFromServerURL(urlString: item.squareThumbnailURL!, PlaceHolderImage: UIImage.init(named: "Getir_Logo_Circle")!)
            }
        }
        else if let item = merged[indexPath.row] as? VerticalProduct {
            cell.nameLabel.text = item.name
            cell.priceLabel.text = item.priceText
            cell.attributeLabel.text = item.shortDescription
            self.totalPrice += (item.price ?? 0.0)
            if item.imageURL != nil {
                
                cell.productImageView?.imageFromServerURL(urlString: item.imageURL!, PlaceHolderImage: UIImage.init(named: "Getir_Logo_Circle")!)
                

            }else{
                cell.imageView?.imageFromServerURL(urlString: item.thumbnailURL!, PlaceHolderImage: UIImage.init(named: "Getir_Logo_Circle")!)

            }
        }
        self.finalPriceLabel.text = "₺ \(String(totalPrice))"
        return cell
    }
    
    
}

// MARK: - CollectionView
extension BasketViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.horizontalItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCell", for: indexPath) as! HorizontalCollectionViewCell
        
        cell.horizontalProduct = horizontalItems[indexPath.row]
        cell.priceLabel.text = horizontalItems[indexPath.row].priceText ?? ""
        cell.nameLabel.text = horizontalItems[indexPath.row].name ?? ""
        cell.attributeLabel.text = horizontalItems[indexPath.row].shortDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if horizontalItems[indexPath.row].imageURL != nil {
            cell.imageView.load(url: URL(string: horizontalItems[indexPath.row].imageURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")!)
        } else {
            cell.imageView.load(url: URL(string: horizontalItems[indexPath.row].squareThumbnailURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")!)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width)
        return CGSize(width: size - 285, height: 170)
        
    }
    
    
}


extension UIImageView {
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        
        if self.image == nil{
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}
