//
//  CoreDataStore.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 06/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import CoreData
import MagicalRecord

public class CoreDataStore {
  public var readContext: NSManagedObjectContext!
  public var savingContext: NSManagedObjectContext!
  
}

public class SqliteStore : CoreDataStore {
  override init() {
    super.init()
    self.readContext = NSManagedObjectContext.mr_default()
    self.savingContext = NSManagedObjectContext.mr_rootSaving()
  }
}

public class InMemoryStore : CoreDataStore {
  override public init() {
    super.init()
    
    // Store coordinator
    let storeCoordinator = NSPersistentStoreCoordinator.mr_coordinatorWithInMemoryStore()
    
    // Create saving context
    self.savingContext = NSManagedObjectContext.mr_newPrivateQueue()
    savingContext.persistentStoreCoordinator = storeCoordinator
    
    // Create new main context
    self.readContext = NSManagedObjectContext.mr_newMainQueue()
    readContext.persistentStoreCoordinator = storeCoordinator
    
    // Changes observer
    self.setupObserver()
  }
  
  func setupObserver() {
    NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: savingContext, queue: OperationQueue.main) { (notification) in
      self.readContext.mergeChanges(fromContextDidSave: notification)
    }
  }
}
