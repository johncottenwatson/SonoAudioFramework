//
//  SAFSquare.swift
//  SonoAudioFramework
//
//  Created by John Watson on 10/28/20.
//

import Foundation

// Takes n >= 0 inputs
public class SAFSquare: SAFOscillator, SAFNode {
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
        return square(frequency, phase, time)
    }
    
    private let square = { (frequency: Float, phase: Float,  time: Float) -> Float in
        let period = 1.0 / Double(frequency)
        let currentTime = Double(time + phase / frequency)
        let position = fmod(currentTime, period)
        let normalizedPosition = position / period
        return (normalizedPosition < 0.5) ? 1.0 : -1.0
    }
}
