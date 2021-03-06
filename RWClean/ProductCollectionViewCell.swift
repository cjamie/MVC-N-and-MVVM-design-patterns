

import UIKit

public class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Outlets

    @IBOutlet internal var imageView: UIImageView!
    @IBOutlet internal var label: UILabel!

    static let reuseIdentifier = "ProductCollectionViewCell"

    // MARK: - Class Constructors

    public class func nib() -> UINib {
        let nibName = "ProductCollectionViewCell"
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }

    // MARK: - UIView

    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        layer.borderWidth = 2.0
    }
}
