//
//  SAFSine.swift
//  SonoAudioFramework
//
//  Created by John Watson on 10/28/20.
//

import Foundation

// Takes n >= 0 inputs
public class SAFSine: SAFOscillator, SAFNode {
    var children: [SAFNode]

    public init(@SAFAudioObjectBuilder builder: () -> [SAFNode]) {
        self.children = builder()
    }
    
    override public init() {
        self.children = [SAFNode] ()
    }
    
    public func update(@SAFAudioObjectBuilder builder: () -> [SAFNode]) {
        self.children = builder()
    }
    
    public func getSample(_ time: Float) -> Float {
        let frequencyRequest = children.reduce(0,  { $0 + $1.getSample(time) } )
        setFrequency(frequency: frequencyRequest, time: time)
        return sine(frequency, phase, time)
    }
    
    private let sine = { (frequency: Float, phase: Float, time: Float) -> Float in
        let currentTime = time + phase / frequency
        return sin(2.0 * Float.pi * frequency * currentTime)
    }
}
