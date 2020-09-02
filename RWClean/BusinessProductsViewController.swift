
import UIKit

public class BusinessProductsViewController: UIViewController {
    // MARK: - Instance Properties

    internal var imageTasks: [IndexPath: URLSessionDataTask] = [:]
    internal var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    let productLoader: ProductLoader = NetworkClient.shared
    
    // MARK: - Outlets

    @IBOutlet internal var collectionView: UICollectionView! {
        didSet {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(loadProducts), for: .valueChanged)
            collectionView.refreshControl = refreshControl

            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            collectionView.collectionViewLayout = CollectionViewCenterFlowLayout(layout: layout)
        }
    }

    @objc internal func loadProducts() {
        collectionView.refreshControl?.beginRefreshing()

        productLoader.getProducts(for: .business) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.products = products
            case .failure(let error):
                print("-=- \(self) \(error.localizedDescription)")
            }
            self.collectionView.refreshControl?.endRefreshing()

        }
    
    }

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let selectedItem = collectionView.indexPathsForSelectedItems else { return }
        selectedItem.forEach { collectionView.deselectItem(at: $0, animated: false) }
    }

    // MARK: - Segue

    public override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let viewController = segue.destination as? ProductDetailsViewController else { return }
        let indexPath = collectionView.indexPathsForSelectedItems!.first!
        let product = products[indexPath.row]
        viewController.product = product
    }
}

// MARK: - UICollectionViewDataSource

extension BusinessProductsViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return products.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let product = products[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.label.text = product.title

        imageTasks[indexPath]?.cancel()

//        if let url = product.imageURL {
//            let task = session.dataTask(with: url, completionHandler: { [weak cell]
//                data, _, error in
//
//                if let error = error {
//                    print("Image download failed: \(error)")
//                    return
//                }
//
//                guard let cell = cell,
//                    let data = data,
//                    let image = UIImage(data: data) else {
//                    print("Image download failed: invalid image data!")
//                    return
//                }
//                DispatchQueue.main.async { [weak cell] in
//                    guard let cell = cell else { return }
//                    cell.imageView.image = image
//                }
//      })
//            imageTasks[indexPath] = task
//            task.resume()
//        }
        return cell
    }
}
