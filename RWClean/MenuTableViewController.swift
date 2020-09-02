
import UIKit

public class MenuTableViewController: UITableViewController {
    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        configureTableView()
    }

    private func configureBackButton() {
        let image = UIImage(named: "menu")!
        let backButton = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem = backButton
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDelegate

    private struct CellIdentifiers {
        static let products = "ProductsCell"
        static let homeInfo = "HomeInfoCell"
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else { return }
        switch cellIdentifier {
        case CellIdentifiers.products: showCleaningServicesController()
        case CellIdentifiers.homeInfo: showHomeInfoController()
        default: break
        }
    }

    fileprivate func showCleaningServicesController() {
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "CleaningServices", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! UINavigationController
        splitViewController!.showDetailViewController(viewController, sender: nil)
    }

    fileprivate func showHomeInfoController() {
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "HomeInfoBuilder", bundle: bundle)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController as! HomeInfoViewController
        viewController.delegate = self
        viewController.homeInfo = MutableHomeInfo()

        splitViewController!.showDetailViewController(viewController, sender: nil)
    }
}

// MARK: - HomeInfoBuilderDelegate

extension MenuTableViewController: HomeInfoBuilderDelegate {
    public func homeInfoBuilderCompleted(_: HomeInfo) {
        navigationController?.viewControllers = [self]
        showCleaningServicesController()
    }
}
