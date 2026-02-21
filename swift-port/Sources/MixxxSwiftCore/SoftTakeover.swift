import Foundation

public struct SoftTakeover {
    public static let defaultTakeoverThreshold: Double = 3.0 / 128.0
    public static let subsequentValueOverrideTime: TimeInterval = 0.050

    private var firstValue = true
    private var lastAcceptedTime: TimeInterval = 0
    private var prevParameter: Double = 0
    private var threshold: Double = SoftTakeover.defaultTakeoverThreshold

    public init() {}

    public mutating func setThreshold(_ newThreshold: Double) {
        threshold = newThreshold
    }

    public mutating func ignoreNext() {
        firstValue = true
    }

    public func willIgnore(
        currentParameter: Double,
        newParameter: Double,
        currentTime: TimeInterval
    ) -> Bool {
        if firstValue {
            return true
        }

        if currentTime < lastAcceptedTime + SoftTakeover.subsequentValueOverrideTime {
            return false
        }

        let difference = currentParameter - newParameter
        let prevDiff = currentParameter - prevParameter

        if difference.sign != prevDiff.sign {
            return false
        }

        if abs(difference) <= threshold || abs(prevDiff) <= threshold {
            return false
        }

        return true
    }

    @discardableResult
    public mutating func ignore(
        currentParameter: Double,
        newParameter: Double,
        currentTime: TimeInterval
    ) -> Bool {
        let shouldIgnore: Bool

        if firstValue {
            shouldIgnore = true
            firstValue = false
        } else {
            shouldIgnore = willIgnore(
                currentParameter: currentParameter,
                newParameter: newParameter,
                currentTime: currentTime
            )
        }

        if !shouldIgnore {
            lastAcceptedTime = currentTime
        }

        prevParameter = newParameter
        return shouldIgnore
    }
}
