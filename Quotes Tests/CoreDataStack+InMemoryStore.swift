//
//  CoreDataStack+InMemoryStore.swift
//  Quotes
//
//  Created by Tomasz Szulc on 09/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Model

extension CoreDataStack {
    class func setupTestableStore() {
        let bundle = NSBundle(forClass: CoreDataStack.self)
        let model = CoreDataModel(name: "Model", bundle: bundle)
        let stack = CoreDataStack(model: model, storeType: NSInMemoryStoreType, concurrencyType: .MainQueueConcurrencyType)
        CoreDataStack.setSharedInstance(stack)
    }
}