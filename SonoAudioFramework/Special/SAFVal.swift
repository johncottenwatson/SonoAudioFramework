//
//  SAFVal.swift
//  SonoAudioFramework
//
//  Created by John Watson on 10/28/20.
//

import Foundation

// Takes 0 inputs
public class SAFVal: SAFNode {
    public var val: Float
    
    public init(_ val: Float) {
        self.val = val
    }
    
    public func getSample(_ time: Float) -> Float {
        return val
    }
}
