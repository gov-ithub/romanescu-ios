//
//  DataProvider.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 06/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MagicalRecord

// Response handler
public typealias DataResponseHandler = (_ result: Any?, _ errorMessage: String?) -> Void

enum ApiPath {
  case CallType
  
  func path() -> String {
    switch self {
    case .CallType: return "/call/type"
    }
  }
  
}

public class DataProvider {
  
  public var dataStore : CoreDataStore = {
    MagicalRecord.setLoggingLevel(.off)
    MagicalRecord.setupAutoMigratingCoreDataStack()
    
    return SqliteStore()
  }()
  
  // APi
  var kNetworkApiURL : String
  
  // Generic error
  let kGenericError = "An error occured. Please try again later"
  
  // Api manager
  var manager : Alamofire.SessionManager!
  
  public init(apiNetworkUrl: String) {
    self.kNetworkApiURL = apiNetworkUrl
    
    // Network
    self.initNetworkManager()
  }
}
