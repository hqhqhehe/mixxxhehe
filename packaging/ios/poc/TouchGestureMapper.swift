import Foundation
import CoreGraphics

enum DeckAction {
    case play(deck: Int)
    case cue(deck: Int)
    case sync(deck: Int)
    case setFader(deck: Int, value: Double)
    case setEQ(deck: Int, band: EQBand, value: Double)
    case setCrossfader(value: Double)
}

enum EQBand {
    case low
    case mid
    case high
}

struct TouchGestureMapper {
    func mapFaderDrag(locationY: CGFloat, height: CGFloat, deck: Int) -> DeckAction {
        let normalized = max(0.0, min(1.0, 1.0 - (locationY / max(height, 1.0))))
        return .setFader(deck: deck, value: normalized)
    }

    func mapEQDrag(deltaY: CGFloat, current: Double, deck: Int, band: EQBand) -> DeckAction {
        let step = Double(-deltaY / 240.0)
        let next = max(0.0, min(1.0, current + step))
        return .setEQ(deck: deck, band: band, value: next)
    }

    func mapCrossfaderDrag(locationX: CGFloat, width: CGFloat) -> DeckAction {
        let normalized = max(0.0, min(1.0, locationX / max(width, 1.0)))
        return .setCrossfader(value: normalized)
    }
}
