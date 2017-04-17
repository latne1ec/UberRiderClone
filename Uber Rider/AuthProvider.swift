//
//  AuthProvider.swift
//  Uber Driver
//
//  Created by Evan Latner on 4/17/17.
//  Copyright © 2017 levellabs. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginInErrorCode {
    static let INVALID_EMAIL = "Invalid email, please provide a valdi email address.";
    static let WRONG_PASSWORD = "Incorrect password";
    static let NETWORK_ERROR = "Unknown network error";
}

class AuthProvider {
    private static let _instance = AuthProvider()
    static var Instance: AuthProvider {
        return _instance
    }
    
    
    func login (email: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.HandleErrors(error: error! as NSError, loginHandler: loginHandler)
            } else {
                loginHandler?(nil)
            }
        })
    }
    
    func signup(email: String, password: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.HandleErrors(error: error! as NSError, loginHandler: loginHandler)
            } else {
                if user?.uid != nil {
                    // store user in db
                    DBProvider.Instance.saveUserToDB(id: user!.uid, email: email, password: password)
                    
                    // sign in user
                    self.login(email: email, password: password, loginHandler: loginHandler)
                }
            }
        })
    }
    
    func logout () -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        return true
    }
    
    private func HandleErrors(error: NSError, loginHandler: LoginHandler?) {
        if let errCode = FIRAuthErrorCode(rawValue: error.code) {
            switch errCode {
            case .errorCodeInvalidEmail:
                loginHandler?(LoginInErrorCode.INVALID_EMAIL)
                break;
            case .errorCodeWrongPassword:
                loginHandler?(LoginInErrorCode.WRONG_PASSWORD)
                break;
            case .errorCodeNetworkError:
                loginHandler?(LoginInErrorCode.NETWORK_ERROR)
                break;
            default:
                loginHandler?(LoginInErrorCode.NETWORK_ERROR)
                break;
            }
        }
    }
}
