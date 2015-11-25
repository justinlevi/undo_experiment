//
//  GCDHelpers.swift
//
//

import Foundation

func runQueue(after after: Double, queue: dispatch_queue_t!, block: dispatch_block_t!) {
  if after == 0 {
    dispatch_async(queue, block);
  } else {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(after * Double(NSEC_PER_SEC))), queue, block)
  }
}

func runMain(block: dispatch_block_t!) {
  runMain(after: 0, block: block)
}

func runBackground(block: dispatch_block_t!) {
  runBackground(after: 0, block: block)
}

func runMain(after after: Double, block: dispatch_block_t!) {
  runQueue(after: after, queue: dispatch_get_main_queue(), block: block)
}

func runBackground(after after: Double, block: dispatch_block_t!) {
  runQueue(after: after, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block: block)
}
