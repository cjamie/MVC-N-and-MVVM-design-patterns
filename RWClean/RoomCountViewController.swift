
import UIKit

public class RoomCountViewController: HomeInfoViewController {
    // MARK: - Instance Properties

    internal var initialCount: UInt {
        return 0
    }

    internal var count: UInt {
        get {
            return _count
        } set {
            _count = newValue
            label.text = "\(newValue)"
        }
    }

    private var _count: UInt = 0

    // MARK: - Outlets

    @IBOutlet internal final var label: UILabel!
    @IBOutlet internal final var stepper: UIStepper!

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCount()
    }

    private func setupCount() {
        count = initialCount
        stepper.value = Double(initialCount)
    }

    // MARK: - Actions

    @IBAction internal final func stepperValueChanged(_ sender: UIStepper) {
        count = UInt(sender.value)
    }
}
