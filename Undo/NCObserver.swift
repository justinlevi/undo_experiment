//
//  NCObserver.swift
//
//

import Foundation

typealias InfoDictionary = [NSObject: AnyObject]
typealias InfoBlock = (userInfo: InfoDictionary) -> Void

class NCObserver: NSObject {
  let name: NotificationName
  let block: InfoBlock

  convenience init(name: NotificationName, block: InfoBlock) {
    self.init(name: name, object: nil, block: block)
  }

  init(name: NotificationName, object: AnyObject?, block: InfoBlock) {
    self.name = name
    self.block = block
    super.init()
    Notifications.addObserver(self, selector: "notification:", name: name, object: object)
  }

  func notification(notification: NSNotification) {
    block(userInfo: notification.userInfo ?? InfoDictionary())
  }

  deinit {
    Notifications.removeObserver(self)
  }
}
