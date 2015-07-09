//
//  AppDelegate.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

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
}

