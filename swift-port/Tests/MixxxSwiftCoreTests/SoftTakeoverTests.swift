import XCTest
@testable import MixxxSwiftCore

final class SoftTakeoverTests: XCTestCase {
    func testFirstValueIgnored() {
        var st = SoftTakeover()
        XCTAssertTrue(st.ignore(currentParameter: 0.5, newParameter: 0.1, currentTime: 0.0))
    }

    func testSecondValueQuicklyAfterAcceptIsNotIgnored() {
        var st = SoftTakeover()
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.1, currentTime: 0.0)

        XCTAssertFalse(st.ignore(currentParameter: 0.5, newParameter: 0.9, currentTime: 0.01))
    }

    func testFarSameSideAfterThresholdIsIgnored() {
        var st = SoftTakeover()
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.1, currentTime: 0.0)
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.2, currentTime: 0.01)

        XCTAssertTrue(st.ignore(currentParameter: 0.5, newParameter: 0.1, currentTime: 0.20))
    }

    func testCrossingCurrentValueIsNotIgnored() {
        var st = SoftTakeover()
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.1, currentTime: 0.0)
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.2, currentTime: 0.01)

        XCTAssertFalse(st.ignore(currentParameter: 0.5, newParameter: 0.9, currentTime: 0.20))
    }

    func testIgnoreNextForcesNextEventIgnored() {
        var st = SoftTakeover()
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.1, currentTime: 0.0)
        _ = st.ignore(currentParameter: 0.5, newParameter: 0.9, currentTime: 0.01)

        st.ignoreNext()
        XCTAssertTrue(st.ignore(currentParameter: 0.5, newParameter: 0.9, currentTime: 0.5))
    }
}
