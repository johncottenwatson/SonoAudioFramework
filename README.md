# SonoAudioFramework

SonoAudioFramework is a set of tools written in Swift designed to enable real-time audio synthesis in iOS / macOS with minimal code.

### How to Use
SonoAudioFramework provides a singleton SAFAudioRenderer object, which renders a tree of SAFNodes, each of which represents a simple oscillator, constant value signal, signal operator, or logical operator (see a full list of SAFNode types below).

### Example 1
This code produces a sine wave at 440 Hz
```
// Change the root of the SAFAudioRenderer to our sine oscillator
SAFAudioRenderer.root = SAFSine {
    SAFVal(440)
}
// Turn audio renderer on
SAFAudioRenderer.volume = 0.5
```

### Example 2
This code makes a  monophonic synth with harmonics and an LFO
```
// Create a node for the base frequency
var baseFrequency = SAFVal(440)
// Interval ratios of all the harmonics (including base harmonic)
var harmonics = [SAFVal(1.0), SAFVal(1.25), SAFVal(1.5), SAFVal(2.0)]
// Create a node for the LFO speed
var lfoSpeed = SAFVal(4.5)
// One oscillator of the synth with the LFO applied to its frequency
func osc (frequency: SAFVal, interval: SAFVal) -> (SAFNode) {
    return SAFTriangle() {
        SAFMultiply() {
            frequency
            interval
        }
        SAFMultiply() {
            SAFMultiply() {
                frequency
                SAFVal(0.01)
            }
            SAFSine() {
                lfoSpeed
            }
        }
    }
}
// Change the root of the SAFAudioRenderer to our synth
SAFAudioRenderer.root = SAFMultiply {
    SAFVal(0.25)
    SAFAdd() {
        osc(frequency: baseFrequency, interval: harmonics[0])
        osc(frequency: baseFrequency, interval: harmonics[1])
        osc(frequency: baseFrequency, interval: harmonics[2])
        osc(frequency: baseFrequency, interval: harmonics[3])
    }
}
// Turn audio renderer on
SAFAudioRenderer.volume = 0.5
// Change baseFrequency.val to change frequency of synth in real time
// Change harmonics[n].val to change harmonic n of synth in real time
// Change lfoSpeed.val to change LFO speed of synth in real time
```


### Current SAFNode Types
**Operators:**\
SAFAdd - outputs the sum of the current samples of all inputs\
SAFMultiply - outputs the product of the current samples of all inputs

**Oscillators:**\
SAFSine – outputs a simple sine wave, with sum of inputs as frequency\
SAFTriangle – outputs a triangle wave, with sum of inputs as frequency\
SAFSaw – outputs a sawtooth wave, with sum of inputs as frequency\
SAFSquare – outputs a square wave, with sum of inputs as frequency

**Other:**\
SAFVal – a simple node which takes no inputs and outputs a constant signal

**Coming Soon**\
SAFLine\
SAFMap\
SAFCycle

