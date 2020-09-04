import UIKit

internal class RegisterViewController: UIViewController {
    // MARK: - Injections

    internal var delegate: AuthControllerDelegate!

    // MARK: - Outlets

    @IBOutlet internal var emailTextField: UITextField!
    @IBOutlet internal var passwordTextField: UITextField!
    @IBOutlet internal var firstNameTextField: UITextField!
    @IBOutlet internal var lastNameTextField: UITextField!
    @IBOutlet internal var phoneNumberTextField: UITextField!

    // MARK: - Actions

    @IBAction func registerButtonPressed(_: Any) {
        attemptRegister()
    }

    private func attemptRegister() {
        guard let email = emailTextField.text, EmailValidator.validate(input: email) else {
            showEmailInvalidAlert()
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty,
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showMissingInputAlert()
            return
        }

        delegate.registerRequested(
            on: self,
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            failure: { [weak self] error in
                guard let strongSelf = self else { return }
                switch error {
                case .emailTaken:
                    strongSelf.showEmailTakenAlert()
                case .unknown:
                    fallthrough
                case .networkProblem:
                    strongSelf.showCheckInternetConnectionAlert()
                }
            }
        )
    }

    private func showEmailInvalidAlert() {
        let controller = UIAlertController(title: NSLocalizedString("Invalid Email", comment: ""),
                                           message: NSLocalizedString("Please check your e-mail input and try again", comment: ""),
                                           preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                           style: .default))

        present(controller, animated: true)
    }

    private func showMissingInputAlert() {
        let controller = UIAlertController(title: NSLocalizedString("Missing Input(s)", comment: ""),
                                           message: NSLocalizedString("Please check your inputs and try again", comment: ""),
                                           preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                           style: .default))

        present(controller, animated: true)
    }

    private func showCheckInternetConnectionAlert() {
        let controller = UIAlertController(title: NSLocalizedString("Networking Error", comment: ""),
                                           message: NSLocalizedString("Please check your internet connection and try again", comment: ""),
                                           preferredStyle: .alert)

        let retry = UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.attemptRegister()
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)

        controller.addAction(retry)
        controller.addAction(cancel)

        present(controller, animated: true)
    }

    private func showEmailTakenAlert() {
        let controller = UIAlertController(title: NSLocalizedString("Email Already Registered", comment: ""),
                                           message: NSLocalizedString("Please register with a different email", comment: ""),
                                           preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                           style: .default))

        present(controller, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()

        } else if textField == passwordTextField {
            firstNameTextField.becomeFirstResponder()

        } else if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()

        } else if textField == lastNameTextField {
            phoneNumberTextField.becomeFirstResponder()
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard textField == phoneNumberTextField else { return true }
        let validCharacters = "0123456789".characters
        return string.characters.filter(validCharacters.contains).count == string.characters.count
    }
}
