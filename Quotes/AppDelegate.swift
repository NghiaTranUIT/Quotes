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
        print("Received a payload via handoff: \(userActivity.userInfo)")
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            // If QuoteListViewController presents something modally just dismiss it
            if let presentedViewController = navigationController.presentedViewController {
                presentedViewController.dismissViewControllerAnimated(false, completion: nil)
            }
            
            // If QuoteListViewController present some view via Push pop to root
            if (navigationController.topViewController is QuotesListViewController) == false {
                navigationController.popToRootViewControllerAnimated(false)
            }
            
            navigationController.topViewController?.restoreUserActivityState(userActivity)
        }
        
        return true
    }
}

