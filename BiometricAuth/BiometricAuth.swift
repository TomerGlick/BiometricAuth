//
//  BiometricAuth.swift
//  BiometricAuth
//
//  Created by Tomer Glick New on 31/07/2019.
//  Copyright © 2019 Tomer Glick. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricSupportType : String {
    case touchId = "Touch ID"
    case faceId = "Face ID"
    case none = "none"
}

public struct BiometricAuth {
  
    typealias AuthenticationSuccessBlock =  (_ bool: Bool  , _ errorMessage:String?) -> Void
    
    static func isDeviceSupportsBiometricAuth () -> Bool {
        let  context = LAContext()
        var policy: LAPolicy?
        policy = .deviceOwnerAuthentication
        var err: NSError?
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            return false
        }
        return true
    }
    
    static func supportedBiometricType () -> BiometricSupportType
    {
        let context = LAContext()
        context.touchIDAuthenticationAllowableReuseDuration = 10;
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            if (context.biometryType == LABiometryType.faceID) {
                return .faceId
            } else if context.biometryType == LABiometryType.touchID {
                return .touchId
            }
        }
        return .none
    }
    
    static func isValidUser(reason:String , authSuccess: @escaping AuthenticationSuccessBlock = { _,_  in })
    {
        let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        let context = LAContext()
        
        context.evaluatePolicy(policy, localizedReason: reason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                if success {
                    authSuccess(true  , nil)
                }
                else {
                    guard let error = error else {
                        authSuccess(false  , "UnknownError")
                        return
                    }
                    switch (error)  {
                    case LAError.authenticationFailed:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.userCancel:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.userFallback:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.systemCancel:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.passcodeNotSet:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.biometryNotAvailable:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.biometryNotEnrolled:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.biometryLockout:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.appCancel:
                        authSuccess(false  , error.localizedDescription)
                        break
                    case LAError.invalidContext:
                        authSuccess(false  , error.localizedDescription)
                        break
                    default:
                        break
                    }
                    return
                }
            }
        })
    }
}
