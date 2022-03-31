//
//  LocalAuthorizationService.swift
//  SecurityAuthorization
//
//  Created by Misha on 30.03.2022.
//

import LocalAuthentication
import UIKit

class LocalAuthorizationService {
    
    let laContext = LAContext()
    
    var error: NSError?
    
    private var completionHandler: ((Bool) -> Void)? //Тут мы храним замыкание
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        completionHandler = authorizationFinished //Помогаем замыканию выжить в области действия функции, сохраняя его вне функции
        //проверка возможности использования биометрии
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //можем использовать
            let reason = "Please authorize with Touch ID!"
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success, error == nil else {
                        //failed
                        self?.completionHandler!(false)
                        return
                    }
                    //авторизация по биометрии
                    self?.completionHandler!(true)
                }
            }
        } else {
            //не можем использовать
            self.completionHandler!(false)
        }
    }
}
