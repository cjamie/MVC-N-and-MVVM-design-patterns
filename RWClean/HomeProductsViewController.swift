
import UIKit

public class HomeProductsViewController: UIViewController {
    // MARK: - Instance Properties

    internal var imageTasks: [IndexPath: URLSessionDataTask] = [:]
    internal var products: [Product] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    internal let session = URLSession.shared
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

        productLoader.getProducts(for: .home) { [weak self] homeProductResult in
            switch homeProductResult {
            case let .failure(networkError):
                print("-=- network error \(networkError.localizedDescription)")
            case let .success(products):
                self?.products = products
            }
            self?.collectionView.refreshControl?.endRefreshing()
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
        viewController.viewModel = ProductDetailsViewController.ViewModel(product: product)
    }
}

// MARK: - UICollectionViewDataSource

extension HomeProductsViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return products.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "ProductCell"

        let product = products[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! ProductCollectionViewCell
        cell.label.text = product.title

        imageTasks[indexPath]?.cancel()

        if let url = product.imageURL {
            let task = session.dataTask(with: url, completionHandler: { [weak cell]
                data, _, error in

                if let error = error {
                    print("Image download failed: \(error)")
                    return
                }

                guard let cell = cell,
                    let data = data,
                    let image = UIImage(data: data) else {
                    print("Image download failed: invalid image data!")
                    return
                }
                DispatchQueue.main.async { [weak cell] in
                    guard let cell = cell else { return }
                    cell.imageView.image = image
                }
      })
            imageTasks[indexPath] = task
            task.resume()
        }
        return cell
    }
}
