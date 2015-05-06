//
//  KeyChainWrapper.swift
//  MDRTBHearingScreening
//
//  Created by Laura Greisman on 3/28/15.
//  Copyright (c) 2015 Miguel Clark. All rights reserved.
//

import Foundation


public class KeychainWrap {
    public var serviceIdentifier: String
    
    public init() {
        if let bundle = NSBundle.mainBundle().bundleIdentifier {
            self.serviceIdentifier = bundle
        } else {
            self.serviceIdentifier = "unkown"
        }
    }
    
    func createQuery(# key: String, value: String? = nil) -> NSMutableDictionary {
        var dataFromString: NSData? = value?.dataUsingEncoding(NSUTF8StringEncoding)
        var keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = kSecClassGenericPassword
        keychainQuery[kSecAttrService as String] = self.serviceIdentifier
        keychainQuery[kSecAttrAccount as String] = key
        //keychainQuery[kSecAttrAccessible as String] = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        keychainQuery[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        if let unwrapped = dataFromString {
            keychainQuery[kSecValueData as String] = unwrapped
        } else {
            keychainQuery[kSecReturnData as String] = true
        }
        return keychainQuery
    }
    
    func createQueryForAddItemWithTouchID(# key: String, value: String? = nil) -> NSMutableDictionary {
        var dataFromString: NSData? = value?.dataUsingEncoding(NSUTF8StringEncoding)
        var error:  Unmanaged<CFError>?
        var sac: Unmanaged<SecAccessControl>
        sac = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .UserPresence, &error)
        let retrievedData = Unmanaged<SecAccessControl>.fromOpaque(sac.toOpaque()).takeUnretainedValue()
        
        var keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = kSecClassGenericPassword
        keychainQuery[kSecAttrService as String] = self.serviceIdentifier
        keychainQuery[kSecAttrAccount as String] = key
        keychainQuery[kSecAttrAccessControl as String] = retrievedData
        keychainQuery[kSecUseNoAuthenticationUI as String] = true
        if let unwrapped = dataFromString {
            keychainQuery[kSecValueData as String] = unwrapped
        }
        return keychainQuery
    }
    
    func createQueryForReadItemWithTouchID(# key: String, value: String? = nil) -> NSMutableDictionary {
        var dataFromString: NSData? = value?.dataUsingEncoding(NSUTF8StringEncoding)
        var keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = kSecClassGenericPassword
        keychainQuery[kSecAttrService as String] = self.serviceIdentifier
        keychainQuery[kSecAttrAccount as String] = key
        keychainQuery[kSecUseOperationPrompt as String] = "Do you really want to access the item?"
        keychainQuery[kSecReturnData as String] = true
        
        return keychainQuery
    }
    
    public func addKey(key: String, value: String) -> OSStatus {
        var status: OSStatus = SecItemAdd(createQuery(key: key, value: value), nil)
        //var status: OSStatus = SecItemAdd(createQueryForAddItemWithTouchID(key: key, value: value), nil)
        return status
    }
    
    public func updateKey(key: String, value: String) -> OSStatus {
        let attributesToUpdate = NSMutableDictionary()
        attributesToUpdate[kSecValueData as String] = value.dataUsingEncoding(NSUTF8StringEncoding)!
        var status: OSStatus = SecItemUpdate(createQuery(key: key, value: value), attributesToUpdate)
        return status
    }
    
    public func readKey(key: String, inout value : String?) -> OSStatus? {
        
        var dataTypeRef: Unmanaged<AnyObject>?
        let status: OSStatus = SecItemCopyMatching(createQuery(key: key), &dataTypeRef)
        //let status: OSStatus = SecItemCopyMatching(createQueryForReadItemWithTouchID(key: key), &dataTypeRef)
        
        var contentsOfKeychain: String?
        if (status == errSecSuccess) {
            let opaque = dataTypeRef?.toOpaque()
            if let op = opaque {
                let retrievedData = Unmanaged<NSData>.fromOpaque(op).takeUnretainedValue()
                // Convert the data retrieved from the keychain into a string
                contentsOfKeychain = NSString(data: retrievedData, encoding: NSUTF8StringEncoding) as String?
                value = contentsOfKeychain!
            } else {
                println("Nothing was retrieved from the keychain. Status code \(status)")
            }
        }
        return status
    }
    
    // when uninstalling app you may wish to clear keyclain app info
    public func resetKeychain() -> Bool {
        let result = self.deleteAllKeysForSecClass(kSecClassGenericPassword) &&
            self.deleteAllKeysForSecClass(kSecClassInternetPassword) &&
            self.deleteAllKeysForSecClass(kSecClassCertificate) &&
            self.deleteAllKeysForSecClass(kSecClassKey) &&
            self.deleteAllKeysForSecClass(kSecClassIdentity)
        println(result)
        return result
    }
    
    func deleteAllKeysForSecClass(secClass: CFTypeRef) -> Bool {
        var keychainQuery = NSMutableDictionary()
        keychainQuery[kSecClass as String] = secClass
        let result:OSStatus = SecItemDelete(keychainQuery)
        if (result == errSecSuccess || result == errSecItemNotFound) {
            return true
        } else {
            return false
        }
    }
    
    // MARK : - error messages
    
    /*
    errSecSuccess                               = 0,       /* No error. */
    errSecUnimplemented                         = -4,      /* Function or operation not implemented. */
    errSecIO                                    = -36,     /*I/O error (bummers)*/
    errSecOpWr                                  = -49,     /*file already open with with write permission*/
    errSecParam                                 = -50,     /* One or more parameters passed to a function where not valid. */
    errSecAllocate                              = -108,    /* Failed to allocate memory. */
    errSecUserCanceled                          = -128,    /* User canceled the operation. */
    errSecBadReq                                = -909,    /* Bad parameter or invalid state for operation. */
    errSecInternalComponent                     = -2070,
    errSecNotAvailable                          = -25291,  /* No keychain is available. You may need to restart your computer. */
    errSecDuplicateItem                         = -25299,  /* The specified item already exists in the keychain. */
    errSecItemNotFound                          = -25300,  /* The specified item could not be found in the keychain. */
    errSecInteractionNotAllowed                 = -25308,  /* User interaction is not allowed. */
    errSecDecode                                = -26275,  /* Unable to decode the provided data. */
    errSecAuthFailed                            = -25293,  /* The user name or passphrase you entered is not correct. */
    */
    
    func keychainErrorToString(error: OSStatus) -> String {
        var msg: String?
        switch(error) {
        case errSecSuccess: msg = "Success"
        case errSecUnimplemented: msg = "Function or operation not implemented"
            //case errSecIO: msg = "IO error (bummers)"
            //case errSecOpWr: msg = "ile already open with with write permission"
        case errSecParam: msg = "ne or more parameters passed to a function where not valid"
        case errSecAllocate: msg = "Failed to allocate memory"
            //case errSecUserCanceled: msg = "User canceled the operation"
            //case errSecBadReq: msg = "Bad parameter or invalid state for operation"
            //case errSecInternalComponent: msg = ""
        case errSecNotAvailable: msg = "No keychain available"
        case errSecDuplicateItem: msg = "Duplicate item, please delete first"
        case errSecItemNotFound: msg = "Item not found"
        case errSecInteractionNotAllowed: msg = "User interaction is not allowed"
        case errSecDecode: msg = "Unable to decode the provided data"
        case errSecAuthFailed: msg = "The user name or passphrase you entered is not correct"
        default: msg = "Error: \(error)"
        }
        
        return msg!
    }
}