import XCTest
@testable import PhantomTypes

final class PhantomTypesTests: XCTestCase {
    func testPropertyWrapperMonoids() {
        struct User {
            typealias Email = Phantom<Self, String>
            typealias Age = Phantom<Self, Int>
            typealias IsAdmin = Phantom<Self, Bool>

            @Email()
            var email: String

            @Age()
            var age: Int

            @IsAdmin()
            var isAdmin: Bool
        }
        let user = User()
        XCTAssertEqual(user.age, 0)
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.isAdmin, false)
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
