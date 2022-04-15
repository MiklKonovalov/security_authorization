//
//  ViewController.swift
//  SecurityAuthorization
//
//  Created by Misha on 30.03.2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    let laContext = LAContext()
    
    let localAuthorizationService: LocalAuthorizationService
    
    var error: NSError?
    
    init(localAuthorizationService: LocalAuthorizationService) {
        self.localAuthorizationService = localAuthorizationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func loginButtonTap() {
        localAuthorizationService.authorizeIfPossible { success, error in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed to Authentificate",
                                                message: "Please try again",
                                                preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                style: .cancel,
                                                handler: nil))
                    self.present(alert, animated: true)
                }
                return
            }
            if success {
                DispatchQueue.main.async {
                    let viewController = UIViewController()
                    viewController.title = "Welcome!"
                    viewController.view.backgroundColor = .blue
                    self.present(UINavigationController(rootViewController: viewController),
                                  animated: true,
                                  completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
    }

}

