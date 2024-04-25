import UIKit

protocol ListingViewControllerProtocol: AnyObject {
    func setupNavigationBar()
    func setupHorizontalScrollView()
    func setupVerticalScrollView()
    func getVerticalData()
    func getHorizontalData()
    func updateBasketView()
    func updateCardData()
}

class ListingViewController: BaseViewController {
    @IBOutlet weak var basketView: UIView!
    @IBOutlet weak var basketLabel: UILabel!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var verticalCollectionView: UICollectionView!
    
    var horizontalItems: [HorizontalProduct] = []
    var verticalItems: [VerticalProduct] = []
    var selectedHorizontalItem: HorizontalProduct?
    var selectedVerticalItem: VerticalProduct?
    public var basket = Basket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHorizontalScrollView()
        setupVerticalScrollView()
        setupNavigationBar()
        getHorizontalData()
        getVerticalData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBasketView()
        horizontalCollectionView.reloadData()
    }
}

// MARK: - Setup
extension ListingViewController: ListingViewControllerProtocol {
    func updateCardData() {
        // Implement if needed
    }
    
    func updateBasketView() {
        var price = Double(basketLabel.text ?? "0.0") ?? 0.0
        
        for horizontalItem in basket.horizontalProduct ?? [] {
            price += Double(horizontalItem.price ?? 0)
        }
        for verticalItem in basket.verticalProduct ?? [] {
            price += Double(verticalItem.price ?? 0)
        }
        basketLabel.text = "₺ \(price)"
        
        basketView.isHidden = basketLabel.text == "0"
    }
    
    func getVerticalData() {
        let verticalURL = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/suggestedProducts")!
        
        ProductsService().getHorizontalItems(url: verticalURL) { [weak self] data in
            guard let self = self else { return }
            self.horizontalItems = data?.first?.products ?? []
            DispatchQueue.main.async {
                self.horizontalCollectionView.reloadData()
            }
        }
    }
    
    func getHorizontalData() {
        let horizontalURL = URL(string: "https://65c38b5339055e7482c12050.mockapi.io/api/products")!
        
        ProductsService().getVerticalItems(url: horizontalURL) { [weak self] data in
            guard let self = self else { return }
            self.verticalItems = data?.first?.products ?? []
            DispatchQueue.main.async {
                self.verticalCollectionView.reloadData()
            }
        }
    }
    
    func setupHorizontalScrollView() {
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "horizontalCell")
    }
    
    func setupVerticalScrollView() {
        verticalCollectionView.dataSource = self
        verticalCollectionView.delegate = self
        verticalCollectionView.showsVerticalScrollIndicator = false
        verticalCollectionView.register(UINib(nibName: "VerticalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "verticalCell")
    }
    
    func setupNavigationBar() {
        basketView.isHidden = true
        basketView.layer.cornerRadius = 10
        basketImageView.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        basketView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "toBasketVC", sender: nil)
    }
}

// MARK: - CollectionView
extension ListingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCollectionView {
            return horizontalItems.count
        } else {
            return verticalItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCell", for: indexPath) as! HorizontalCollectionViewCell
            configureHorizontalCell(cell, at: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verticalCell", for: indexPath) as! VerticalCollectionViewCell
            configureVerticalCell(cell, at: indexPath)
            return cell
        }
    }
    
    private func configureHorizontalCell(_ cell: HorizontalCollectionViewCell, at indexPath: IndexPath) {
        let item = horizontalItems[indexPath.row]
        cell.horizontalBasket = basket.horizontalProduct ?? []
        cell.horizontalProduct = item
        cell.priceLabel.text = item.priceText ?? ""
        cell.nameLabel.text = item.name ?? ""
        cell.attributeLabel.text = item.shortDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.delegate = self
        let url = URL(string: item.imageURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")!
        cell.imageView.load(url: url)
    }
    
    private func configureVerticalCell(_ cell: VerticalCollectionViewCell, at indexPath: IndexPath) {
        let item = verticalItems[indexPath.row]
        cell.delegate = self
        cell.verticalProduct = item
        cell.priceLabel.text = item.priceText ?? ""
        cell.nameLabel.text = item.name ?? ""
        cell.attributeLabel.text = item.shortDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let url = URL(string: item.imageURL ?? "https://cdn.getir.com/marketing/Getir_Logo_1621812382342.png")!
        cell.imageView.load(url: url)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            let size = collectionView.frame.size.width
            return CGSize(width: size - 285, height: 170)
        } else {
            let size = (collectionView.frame.size.width - 25) / 3
            return CGSize(width: size, height: (collectionView.frame.height - 20) / 2.3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == horizontalCollectionView {
            selectedHorizontalItem = horizontalItems[indexPath.row]
        } else {
            selectedVerticalItem = verticalItems[indexPath.row]
        }
        performSegue(withIdentifier: "toProductDetailVC", sender: nil)
    }
}

// MARK: - Segue
extension ListingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductDetailVC" {
            guard let destination = segue.destination as? ProductDetailViewController else { return }
            destination.horizontalProduct = selectedHorizontalItem
            destination.verticalProduct = selectedVerticalItem
            destination.basket = basket
            destination.delegate = self
        } else if segue.identifier == "toBasketVC" {
            guard let destination = segue.destination as? BasketViewController else { return }
            destination.basket = basket
            destination.horizontalItems = horizontalItems
        }
    }
}

// MARK: - ProductDetail Delegate
extension ListingViewController: ProductDetailDelegate {
    func activateBasketView() {
        basketView.isHidden = false
    }
    
    func deactivateBasketView() {
        basketView.isHidden = true
        updateBasketView()
    }
    
    func addHorizontalItem(add: HorizontalProduct) {
        basket.horizontalProduct?.append(add)
        updateBasketView()
    }
    
    func addVerticalItem(add: VerticalProduct) {
        basket.verticalProduct?.append(add)
        updateBasketView()
    }
    
    func deleteHorizontalItem(product: HorizontalProduct) {
        if let index = basket.horizontalProduct?.lastIndex(where: { $0.id == product.id }) {
            basket.horizontalProduct?.remove(at: index)
        }
        updateBasketView()
    }
    
    func deleteVerticalItem(product: VerticalProduct) {
        if let index = basket.verticalProduct?.lastIndex(where: { $0.id == product.id }) {
            basket.verticalProduct?.remove(at: index)
        }
        updateBasketView()
    }
}

// MARK: - HorizontalCollectionViewCell Delegate
extension ListingViewController: HorizontalCollectionViewCellDelegate {
    func addHorizontalProduct(product: HorizontalProduct) {
        basket.horizontalProduct?.append(product)
        updateBasketView()
    }
    
    func deleteHorizontalProduct(product: HorizontalProduct) {
        if let index = basket.horizontalProduct?.lastIndex(where: { $0.id == product.id }) {
            basket.horizontalProduct?.remove(at: index)
        }
        updateBasketView()
    }
}

// MARK: - VerticalCollectionViewCell Delegate
extension ListingViewController: VerticalCollectionViewCellDelegate {
    func addVerticalProduct(product: VerticalProduct) {
        basket.verticalProduct?.append(product)
        updateBasketView()
    }
    
    func deleteVerticalProduct(product: VerticalProduct) {
        if let index = basket.verticalProduct?.lastIndex(where: { $0.id == product.id }) {
            basket.verticalProduct?.remove(at: index)
        }
        updateBasketView()
    }
}

extension ListingViewController: BasketViewControllerDelegate {
    func DeleteBasket() {
        basket = Basket()
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
