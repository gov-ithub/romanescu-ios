//
//  FileManager+Dir.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 07/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import UIKit

extension FileManager {
  
  class func documentsDir() -> String {
    var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
    return paths[0]
  }
  
  class func cachesDir() -> String {
    var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
    return paths[0]
  }
}
