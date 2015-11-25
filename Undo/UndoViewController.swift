//
//  ViewController.swift
//  Undo
//
//  Created by Justin Winter on 4/26/15.
//  Copyright (c) 2015 wintercreative. All rights reserved.
//

import UIKit

class UndoViewController: UIViewController {

  // ============================================
  // MARK: - Properties
  
  let undoer = NSUndoManager()
  
  var undoDidCloseGroupObserver: NCObserver!
  var undoDidUndoChangeObserver: NCObserver!
  var undoDidRedoChangeObserver: NCObserver!
  
  // ============================================
  // MARK: - IBOutlets
  
  @IBOutlet weak var dragView: DragView!
  
  @IBOutlet weak var redoButton: UIButton!
  @IBOutlet weak var redoLabel: UILabel!
  
  @IBOutlet weak var undoButton: UIButton!
  @IBOutlet weak var undoLabel: UILabel!
  
  // ============================================
  // MARK: - Actions
  
  @IBAction func redoButtonDidTap(sender: UIButton) {
    self.undoer.redo()
  }
  
  @IBAction func undoButtonDidTap(sender: UIButton) {
    self.undoer.undo()
  }
  
  
  // ============================================
  // MARK: - ViewController lifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerObservers()
    dragView.undoer = undoer
  
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    runMain(after: 1.0) {
      self.toggleUndo(false)
      self.toggleRedo(false)
    }
  }
  
  func toggleUndo(enabled:Bool) {
    _ = [undoButton, undoLabel].map { enabled ? self.showView($0) : self.hideView($0) }
  }
  
  func toggleRedo(enabled:Bool) {
    _ = [redoButton, redoLabel].map { enabled ? self.showView($0) : self.hideView($0) }
  }
  
  func registerObservers() {
    undoDidCloseGroupObserver = NCObserver(name: .DidCloseUndoGroupNotification) { [unowned self] userInfo in
      self.toggleUndo(self.undoer.canUndo)
      self.toggleRedo(self.undoer.canRedo)
      
    }
    
    undoDidUndoChangeObserver  = NCObserver(name: .DidUndoChangeNotification) { [unowned self] userInfo in
      self.toggleUndo(self.undoer.canUndo)
      self.toggleRedo(self.undoer.canRedo)
    }
    
    undoDidRedoChangeObserver  = NCObserver(name: .DidRedoChangeNotification) { [unowned self] userInfo in
      self.toggleUndo(self.undoer.canUndo)
      self.toggleRedo(self.undoer.canRedo)
    }
  }

  
  // ============================================
  // MARK: - Animation Helpers

  func showView(view: UIView) {
    animate(0.3) {
      view.alpha = 1
    }
    spring {
      view.transform = CGAffineTransformIdentity
    }
  }
  
  func hideView(view: UIView) {
    animate(0.2) {
      view.alpha = 0
      view.transform = self.kTransformScaleSmall
    }
  }
  
  let kTransformScaleSmall = CGAffineTransformMakeScale(0.8, 0.8)
  
  func spring(animations: () -> Void) {
    spring(1.3, damping: 0.28, velocity: 50, animations: animations)
  }
  
  func spring(duration: Double, damping: CGFloat, velocity: CGFloat, animations: () -> Void) {
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .AllowUserInteraction, animations: animations, completion: nil)
  }
  
  func animate(duration: Double, animations: () -> Void) {
    UIView.animateWithDuration(duration, delay: 0, options: .AllowUserInteraction, animations: animations, completion: nil)
  }
  
  func animate(duration: Double, delay: Double, animations: () -> Void) {
    UIView.animateWithDuration(duration, delay: delay, options: .AllowUserInteraction, animations: animations, completion: nil)
  }

}