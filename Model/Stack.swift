//
//  Stack.swift
//  ARKitInteraction
//
//  Created by Nijel Hunt on 4/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

/// Implementation of a stack data structure
///
/// The underlying backing data structure is an array
struct Stack<Type> {
  
  private var array = [Type]()
  
  public mutating func push(_ element: Type) {
    array.append(element)
  }
  
  public mutating func pop() -> Type? {
    return array.popLast()
  }
  
  public var top: Type? {
    return array.last
  }
  
  public var count: Int {
    return array.count
  }
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
}
