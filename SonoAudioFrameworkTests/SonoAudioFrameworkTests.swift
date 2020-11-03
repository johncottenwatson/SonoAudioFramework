//
//  SonoAudioFrameworkTests.swift
//  SonoAudioFrameworkTests
//
//  Created by John Watson on 10/27/20.
//

import XCTest
import Foundation
@testable import SonoAudioFramework

class SonoAudioFrameworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Tests initializing an SAFAudioRenderer
    func testInitialization() throws {
        SAFAudioRenderer.root = SAFVal(0)
        // Make sure audio renderer has initialized corrected by checking initial volume
        XCTAssertEqual(SAFAudioRenderer.volume, 0)
    }
   
    // Tests that an oscillator begins at 0
    func testOscillatorStart() throws {
        let sine = SAFSine() {
            SAFVal(400)
        }
        // Signal should begin at zero
        XCTAssertEqual((sine.getSample(0)), 0)
    }
    
    // Tests the first example shown in the README.md
    func testREADMEExample1() {
        // Change the root of the SAFAudioRenderer to our sine oscillator
        SAFAudioRenderer.root = SAFSine {
            SAFVal(440)
        }
        // Turn audio renderer on
        SAFAudioRenderer.volume = 0.5
        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }
    
    // Tests second example shown in the README.md
    func testREADMEExample2() {
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

        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }
    
    // Tests a simple sine oscillator
    func testSine() {
        SAFAudioRenderer.root = SAFSine() {
            SAFVal(400)
        }
        
        SAFAudioRenderer.volume = 1
        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }
    
    // Tests a simple triangle oscillator
    func testTriangle() {
        SAFAudioRenderer.root = SAFTriangle() {
            SAFVal(400)
        }
        
        SAFAudioRenderer.volume = 1
        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }
    
    // Tests a simple sawtooth oscillator
    func testSaw() {
        SAFAudioRenderer.root = SAFSaw() {
            SAFVal(400)
        }
        
        SAFAudioRenderer.volume = 1
        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }
    
    // Tests a simple square oscillator
    func testSquare() {
        SAFAudioRenderer.root = SAFSquare() {
            SAFVal(400)
        }
        
        SAFAudioRenderer.volume = 1
        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }

    // Tests a more complicated synth composed of oscillators and operators
    func testComposite() {
        SAFAudioRenderer.root = SAFMultiply() {
            SAFVal(0.25)
            SAFAdd() {
                SAFTriangle() {
                    SAFAdd() {
                        SAFVal(200)
                        SAFMultiply() {
                            SAFVal(6)
                            SAFSine() {
                                SAFVal(3.6)
                            }
                        }
                    }
                }
                SAFTriangle() {
                    SAFAdd() {
                        SAFVal(300)
                        SAFMultiply() {
                            SAFVal(6)
                            SAFSine() {
                                SAFVal(3.6)
                            }
                        }
                    }
                }
                SAFTriangle() {
                    SAFAdd() {
                        SAFVal(400)
                        SAFMultiply() {
                            SAFVal(6)
                            SAFSine() {
                                SAFVal(3.6)
                            }
                        }
                    }
                }
                SAFTriangle() {
                    SAFAdd() {
                        SAFVal(500)
                        SAFMultiply() {
                            SAFVal(3)
                            SAFSine() {
                                SAFVal(1.8)
                            }
                        }
                    }
                }
            }
        }
        
        SAFAudioRenderer.volume = 1
        // Play the tone audibly for 5 seconds
        sleep(5)
        SAFAudioRenderer.volume = 0
    }
    
    // Tests updating parameters of an SAFNode
    func testUpdate() {
        let val1 = SAFVal(1)
        let val2 = SAFVal(2)
        let val3 = SAFVal(3)
        let val4 = SAFVal(4)
        var sum = SAFAdd() {
            val1
            val2
        }
        let halfSum = SAFMultiply() {
            sum
            SAFVal(0.5)
        }
        XCTAssertEqual(halfSum.getSample(0), 1.5)
        
        // Show that updating children of some node in the tree works...
        sum.update() {
            val2
            val3
        }
        XCTAssertEqual(halfSum.getSample(0), 2.5)
        
        // ...but changing some reference to that node doesn't
        sum = SAFAdd() {
            val3
            val4
        }
        XCTAssertNotEqual(halfSum.getSample(0), 3.5)
    }
}
