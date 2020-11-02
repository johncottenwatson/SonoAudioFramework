//
//  SAFOscillator.swift
//  SonoAudioFramework
//
//  Created by John Watson on 10/28/20.
//

import Foundation

// Parent class for all oscillators
public class SAFOscillator {

    public var frequency: Float = 0
    public var phase: Float = 0
    
    // When changing frequency, clicks can occur when the old signal
    // jumps instantaneously to the position of the new signal
    // To avoid these clicks, the phase is also updated so that the
    // new wave's amplitude begins where the old one left off
    public func setFrequency(frequency: Float, time: Float) {
        // Update frequency
        let oldFrequency = self.frequency
        self.frequency = frequency
        
        // Update phase
        phase = phase + (oldFrequency - frequency) * time
        phase = fmod(phase, 1.0)
    }
}
