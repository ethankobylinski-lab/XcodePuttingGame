//
//  SequenceAverages.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/7/25.
//


// File: Extensions/Sequence+Average.swift
//  PuttingGameV1

import Foundation

extension Sequence where Element == Int {
    /// Average of an Int sequence as Double
    func average() -> Double {
        let arr = Array(self)
        guard !arr.isEmpty else { return 0 }
        let sum = arr.reduce(0, +)
        return Double(sum) / Double(arr.count)
    }
}

extension Sequence where Element: BinaryFloatingPoint {
    /// Average of a floating‐point sequence
    func average() -> Element {
        let arr = Array(self)
        guard !arr.isEmpty else { return 0 }
        return arr.reduce(0, +) / Element(arr.count)
    }
}
