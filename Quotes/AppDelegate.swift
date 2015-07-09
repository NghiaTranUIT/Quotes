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
        if #available(iOS 9.0, *) {
            if userActivity.activityType == CSSearchableItemActionType {
                if let navigationController = self.window?.rootViewController as? UINavigationController {
                    if (navigationController.topViewController is QuotesListViewController) == false {
                        navigationController.popToRootViewControllerAnimated(false)
                    }
                    
                    navigationController.topViewController?.restoreUserActivityState(userActivity)
                }
                
            } else if userActivity.activityType == ActivityType.BrowseQuote.rawValue {
                self.window?.rootViewController?.restoreUserActivityState(userActivity)
            }
        }
        
        return true
    }
}

