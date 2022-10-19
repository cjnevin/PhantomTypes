import XCTest
@testable import PhantomTypes

final class PhantomTypesTests: XCTestCase {
    func testArray() {
        let sut: Phantom<Self, [String]> = ["a", "b", "c"]
        XCTAssertEqual(sut, ["a", "b", "c"])
        XCTAssertFalse(sut.isEmpty)
    }

    func testBool() {
        let sut: Phantom<Self, Bool> = true
        XCTAssertEqual(sut, true)
    }

    func testDictionary() {
        let sut: Phantom<Self, [String: Int]> = ["a": 1, "b": 2, "c": 3]
        XCTAssertEqual(sut, ["a": 1, "b": 2, "c": 3])
        XCTAssertEqual(sut.keys.count, 3)
    }

    func testFloat() {
        let sut: Phantom<Self, Float> = 12.34
        XCTAssertEqual(sut, 12.34)
    }

    func testInt() {
        let sut: Phantom<Self, Int> = 2
        XCTAssertEqual(sut, 2)
    }

    func testNil() {
        let sut: Phantom<Self, String?> = nil
        XCTAssertEqual(sut, nil)
    }

    func testString() {
        let sut: Phantom<Self, String> = "test"
        XCTAssertEqual(sut, "test")
        XCTAssertFalse(sut.isEmpty)
    }

    func testRestriction() {
        @Restrict(18, { $0 = max(18, min($0, 100)) })
        var sut: Phantom<Self, Int>
        sut = 17
        XCTAssertEqual(sut, 18)
        sut = 101
        XCTAssertEqual(sut, 100)

        @WithinRange(18...100)
        var withinRange: Phantom<Self, Int>
        withinRange = 17
        XCTAssertEqual(withinRange, 18)
        withinRange = 101
        XCTAssertEqual(withinRange, 100)

        @Truncated(maxLength: 5)
        var truncated: Phantom<Self, String>
        truncated = "1234567890"
        XCTAssertEqual(truncated, "12345")

        @Truncated(maxLength: 5)
        var truncatedArray: Phantom<Self, [Int]>
        truncatedArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        XCTAssertEqual(truncatedArray, [1, 2, 3, 4, 5])
    }

    func testRegEx() {
        @RegEx("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        var email: Phantom<Self, String>
        email = "test@test.com"
        XCTAssertEqual(email, "test@test.com")
        email = "test.com"
        XCTAssertEqual(email, "test@test.com")
    }
}
