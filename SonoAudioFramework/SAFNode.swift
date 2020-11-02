//
//  SAFNode.swift
//  SonoAudioFramework
//
//  Created by John Watson on October 27, 2020.
//

import Foundation

@_functionBuilder
public struct SAFAudioObjectBuilder {
    public static func buildBlock() -> [SAFNode] { [] }
    public static func buildBlock(_ audioObjects: SAFNode...) -> [SAFNode] {
        audioObjects
    }
}

public protocol SAFNode: class {
    func getSample(_ time: Float) -> Float
}
