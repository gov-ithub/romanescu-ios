//
//  Request+Cancelable.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 06/12/2016.
//  Copyright © 2016 Work In Progress. All rights reserved.
//

import Foundation
import Alamofire

public protocol Cancelable : class {
  func cancel()
}

extension Request : Cancelable {
  
}
