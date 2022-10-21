import XCTest
@testable import PhantomTypes

final class PhantomTypesTests: XCTestCase {
    func testPropertyWrapper() {
        struct Wrapped {
            typealias IsAdmin = Phantom<Self, Bool>
            @IsAdmin(false)
            var value: Bool
        }
        let wrapped = Wrapped()
        XCTAssertEqual(wrapped.value, false)
    }

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
}
