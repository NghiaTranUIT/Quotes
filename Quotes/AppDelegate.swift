//
//  AppDelegate.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import CoreSpotlight
import Model
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func applicationDidFinishLaunching(application: UIApplication) {
        setupCoreData()
    }
    
    private func setupCoreData() {
        let model = CoreDataModel(name: "Model", bundle: NSBundle(forClass: CoreDataStack.self))
        let stack = CoreDataStack(model: model, storeType: NSSQLiteStoreType, concurrencyType: .MainQueueConcurrencyType)
        CoreDataStack.setSharedInstance(stack)
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let userInfo = userActivity.userInfo as? Dictionary<String, AnyObject> {
                let uniqueIdentifier = userInfo[CSSearchableItemActivityIdentifier] as! String
                print(uniqueIdentifier)
                return true
            }
        }
        
        return false
    }
}

