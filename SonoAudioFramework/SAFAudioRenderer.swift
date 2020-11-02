//
//  SAFAudioRenderer.swift
//  SonoAudioFramework
//
//  Created by John Watson on October 27, 2020.
//
//  AVAudioEngine functionality based on Apple's 2019
//   "Building a Signal Generator" example at:
// https://developer.apple.com/documentation/avfoundation/audio_playback_recording_and_processing/avaudioengine/building_a_signal_generator
//

import AVFoundation
import Foundation

public class SAFAudioRenderer {
    // State
    public static let shared = SAFAudioRenderer()
    public var volume: Float {
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
    private var audioEngine: AVAudioEngine
    private var time: Float = 0
    private let sampleRate: Double
    private let deltaTime: Float

    private lazy var srcNode = AVAudioSourceNode { (_, _, frameCount, audioBufferList) -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let sample = self.root.getSample(self.time)
                self.time += self.deltaTime
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = sample
                }
            }
            return noErr
        }
    public var root: SAFNode
    
    // Init without SAFNode parameters
    public init() {
        // Prepare node (create default node since no parameters were given)
        root = SAFVal(0)
        // Prepare output
        audioEngine = AVAudioEngine()
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        
        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)
        
        // Prepare input
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
        audioEngine.attach(srcNode)
        audioEngine.connect(srcNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 0
        do {
           try audioEngine.start()
        } catch {
           print("Could not start engine: \(error.localizedDescription)")
        }
    }
    
    /**
    // Init with SAFNode parameters
    public init(@SAFAudioObjectBuilder builder: () -> [SAFNode]) {
        // Prepare node
        let SAFNodes = builder()
        if SAFNodes.count != 1 {
            fatalError("Invalid number of parameters for SAFAudioRenderer- expected 1 but got \(SAFNodes.count)")
        }
        node = SAFNodes[0]
        // Prepare output
        audioEngine = AVAudioEngine()
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        
        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)
        
        // Prepare input
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
        audioEngine.attach(srcNode)
        audioEngine.connect(srcNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 0
        do {
           try audioEngine.start()
        } catch {
           print("Could not start engine: \(error.localizedDescription)")
        }
    }
    */
}
