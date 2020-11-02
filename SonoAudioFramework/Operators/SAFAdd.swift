//
//  SAFAdd.swift
//  SonoAudioFramework
//
//  Created by John Watson on 10/28/20.
//

import Foundation

// Takes n >= 0 inputs
public class SAFAdd: SAFNode {
    var children: [SAFNode]

    public init(@SAFAudioObjectBuilder builder: () -> [SAFNode]) {
        self.children = builder()
    }
    
    public init() {
        self.children = [SAFNode] ()
    }
    
    public func update(@SAFAudioObjectBuilder builder: () -> [SAFNode]) {
        self.children = builder()
    }
    
    public func getSample(_ time: Float) -> Float {
        return children.reduce(0,  { $0 + $1.getSample(time) } )
    }
}
