import UIKit

// MARK: - AuthControllerDelegate
internal protocol AuthControllerDelegate {
  
  func signInCancelled(on controller: UIViewController)
  
  func signInRequested(on controller: UIViewController,
                       email: String,
                       password: String,
                       failure: @escaping (SignInError) -> Void)
  
  func registerRequested(on controller: UIViewController,
                         email: String,
                         password: String,
                         firstName: String,
                         lastName: String,
                         phoneNumber: String,
                         failure: @escaping (RegisterError) -> Void)  
}

// MARK: - SignInError
public enum SignInError: Error {
  
  case invalidCredentials
  case networkProblem(Error)
  case unknown(URLResponse?)
  
  internal init(error: Error) {
    self = .networkProblem(error)
  }
  
  internal init(response: URLResponse?) {
    guard let httpResponse = response as? HTTPURLResponse else {
      self = .unknown(response)
      return
    }
    
    switch httpResponse.statusCode {
    case 404: self = .invalidCredentials
    default: self = .unknown(response)
    }
  }
}

// MARK: - RegisterError
internal enum RegisterError: Error {
  
  case emailTaken
  case networkProblem(Error)
  case unknown(URLResponse?)
  
  internal init(error: Error) {
    self = .networkProblem(error)
  }
  
  internal init(response: URLResponse?) {
    guard let httpResponse = response as? HTTPURLResponse else {
      self = .unknown(response)
      return
    }
    switch httpResponse.statusCode {
    case 404: self = .emailTaken
    default: self = .unknown(httpResponse)
    }
  }
}
