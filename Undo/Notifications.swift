//
//  NotificationName.swift
//

import UIKit
import Foundation

enum NotificationName: String {

  case DidCloseUndoGroupNotification = "DidCloseUndoGroupNotification"
  case DidUndoChangeNotification = "DidUndoChangeNotification"
  case DidRedoChangeNotification = "DidRedoChangeNotification"
  
  var string: String {
    switch self {
    case .DidCloseUndoGroupNotification: return NSUndoManagerDidCloseUndoGroupNotification
    case .DidUndoChangeNotification: return NSUndoManagerDidUndoChangeNotification
    case .DidRedoChangeNotification: return NSUndoManagerDidRedoChangeNotification
    }
  }
}

class Notifications {
  class var notificationCenter: NSNotificationCenter {
    return NSNotificationCenter.defaultCenter()
  }

  class func addObserver(observer: AnyObject, selector: Selector, name: NotificationName, object: AnyObject? = nil) {
    notificationCenter.addObserver(observer, selector: selector, name: name.string, object: object)
  }

  class func postNotification(name: NotificationName, object: AnyObject? = nil, userInfo: [NSObject: AnyObject]? = nil) {
    notificationCenter.postNotificationName(name.string, object: object, userInfo: userInfo)
  }

  class func removeObserver(observer: AnyObject, name: NotificationName? = nil, object: AnyObject? = nil) {
    notificationCenter.removeObserver(observer, name: name?.string ?? nil, object: object)
  }
}
