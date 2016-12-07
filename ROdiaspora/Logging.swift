//
//  Logging.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 06/12/2016.
//  Copyright © 2016 Work In Progress. All rights reserved.
//

import Foundation

public func DLog<T>( object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
  #if DEBUG
    let queue = Thread.isMainThread ? "UI" : "BG"
    print("<\(queue)>: \(object())")
  #endif
}
