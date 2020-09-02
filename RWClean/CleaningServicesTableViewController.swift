
import UIKit

public class CleaningServicesTableViewController: UITableViewController {
    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDelegate

    public override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    public override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
