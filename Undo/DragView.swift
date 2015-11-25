//
//  DragView.swift
//  Undo
//
//  Created by Justin Winter on 4/26/15.
//  Copyright (c) 2015 wintercreative. All rights reserved.
//

import UIKit

@IBDesignable
class DragView: UIView {
  
  let color = UIColor.randomColor()
  
  var undoer:NSUndoManager? // to be set by VC - might be better to handle this with delegates
  /* 

  The init(frame:) the default initializer. - ONLY CALLED WHEN VIEW IS INITIALIZED IN CODE!
  call it only after initializing your instance variables.
  
  If this view is being reconstituted from a Nib then your custom initializer will not be called,
  Instead the init(coder:) is called
  
  Can also initialize in awakeFromNib()
  
  */

  
  // ================================
  // MARK: - Iniatializers
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    backgroundColor = color
    //layer.cornerRadius = frame.width / 2
    
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragging:"))
    
    addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "longPress:"))
  }
  
  // CALLED AFTER BEING "RECONSTITUTED" FROM THE NIB
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // NOT CALLED - LEFT IN HERE AS A REMINDER
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  
  // ================================
  // MARK: - Redo / Undo
  
  func setCenterUndoably(newCenter:CGPoint) {
    undoer?.prepareWithInvocationTarget(self).setCenterUndoably(center)
    undoer?.setActionName("Move")
    
    if (undoer!.undoing || undoer!.redoing) {
      UIView.animateWithDuration(0.4, delay: 0.1, options: [], animations: {
        self.center = newCenter
        }, completion: nil)
    } else {
      // just do it
      center = newCenter
    }
  }
  
  
  // ================================
  // MARK: - Gesture Recognizers
  
  func dragging(pgr:UIPanGestureRecognizer) {
    switch pgr.state {
    case .Began: grabDot(gesture: pgr); self.undoer?.beginUndoGrouping()
    case .Changed: moveDot(gesture: pgr)
    case .Ended, .Cancelled: dropDot(gesture: pgr); self.undoer?.endUndoGrouping(); self.becomeFirstResponder()
    default: break
    }
  }
  
  // Animate the dot under the center of the gesture
  func grabDot(gesture pgr:UIPanGestureRecognizer){
    UIView.animateWithDuration(0.2, animations: { _ in
      self.transform = CGAffineTransformMakeScale(1.2, 1.2)
      self.alpha = 0.8
      self.setCenterUndoably(pgr.locationInView(self.superview))
    })
  }
  
  func moveDot(gesture pgr:UIPanGestureRecognizer) {
    // Delta is from the touch's initial position
    let delta = pgr.translationInView(superview!)
    setCenterUndoably(CGPointMake(center.x + delta.x, center.y + delta.y))
    
    // reset the pgr delta to new location
    pgr.setTranslation(CGPointZero, inView: superview!)
  }
  
  // Animate the dot back to it's original size/alpha
  func dropDot(gesture pgr:UIPanGestureRecognizer) {
    UIView.animateWithDuration(0.2, animations: { _ in
      self.transform = CGAffineTransformIdentity
      self.alpha = 1
    })
  }
  
  func longPress(g:UIGestureRecognizer){
    if g.state == .Began {
      let m = UIMenuController.sharedMenuController()
      m.setTargetRect(self.bounds, inView: self)
      let mi1 = UIMenuItem(title: undoer!.undoMenuItemTitle, action: "undo:")
      let mi2 = UIMenuItem(title: undoer!.redoMenuItemTitle, action: "redo:")
      m.menuItems = [mi1, mi2]
      m.setMenuVisible(true, animated: true)
    }
  }
  
  
  // ================================
  // MARK: - Undo Menu
  
  override func canBecomeFirstResponder() -> Bool {
    return true
  }
  
  override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
    if action == Selector("undo:") {
      return undoer!.canUndo
    }
    if action == Selector("redo:") {
      return undoer!.canRedo
    }
    return super.canPerformAction(action, withSender: sender)
  }
  
  func undo(_:AnyObject?){
    undoer!.undo()
  }
  
  func redo(_:AnyObject?){
    undoer!.redo()
  }
  
}
