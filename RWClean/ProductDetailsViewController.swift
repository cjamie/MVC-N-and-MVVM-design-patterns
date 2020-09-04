

import UIKit

protocol ProductViewModel {
    var description: String { get }
    var imageURL: URL? { get }
    var priceDescription: String { get }
}

public class ProductDetailsViewController: UIViewController {
    // MARK: - Injections

    var viewModel: ProductViewModel!

    // MARK: - Public

    struct ViewModel: ProductViewModel {
        private let product: Product

        private static let numberFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "en_US")
            numberFormatter.numberStyle = .currency
            return numberFormatter
        }()

        init(product: Product) {
            self.product = product
        }

        // MARK: - ProductViewModel

        var description: String {
            product.productDescription
        }

        var imageURL: URL? {
            product.imageURL
        }

        var priceDescription: String {
            if product.priceHourly > 0 {
                let price = Self.numberFormatter.string(from: product.priceHourly as NSNumber)!
                return "Only \(price) / hour"

            } else if product.priceSquareFoot > 0 {
                let price500SqFt = product.priceSquareFoot * 500
                let price = Self.numberFormatter.string(from: price500SqFt as NSNumber)!
                return "\(price) / 500 ft²"
            } else {
                return "Contact Us For Pricing"
            }
        }
    }

    // MARK: - Outlets

    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var priceLabel: UILabel!

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.priceDescription
        descriptionLabel.text = viewModel.description
    }

    // MARK: - Actions

    @IBAction func makeReservationPressed(_: Any) {}
}
