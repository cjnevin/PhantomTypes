import Foundation
import EmptiableTypes
import MonoidTypes
import WrappedTypes

@dynamicMemberLookup
public struct Phantom<Context, WrappedValue>: WrappedType {
    public var wrappedValue: WrappedValue

    public init(_ wrappedValue: WrappedValue) {
        self.wrappedValue = wrappedValue
    }

    public subscript<T>(dynamicMember member: KeyPath<WrappedValue, T>) -> T {
        get { return wrappedValue[keyPath: member] }
    }
}

// MARK: - CustomDebugStringConvertible

extension Phantom: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(Context.self)(\"\(wrappedValue)\")"
    }
}

// MARK: - Common Conformances

extension Phantom: Comparable where WrappedValue: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }
}
extension Phantom: Equatable where WrappedValue: Equatable {}
extension Phantom: Hashable where WrappedValue: Hashable {}
extension Phantom: Decodable where WrappedValue: Decodable {}
extension Phantom: Encodable where WrappedValue: Encodable {}

extension Phantom: Sequence where WrappedValue: Sequence {
    public typealias Element = WrappedValue.Element
    public typealias Iterator = WrappedValue.Iterator
    public func makeIterator() -> Iterator {
        wrappedValue.makeIterator()
    }
}

// MARK: - ExpressibleBy...Literals

extension Phantom: ExpressibleByArrayLiteral where WrappedValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: WrappedValue.ArrayLiteralElement...) {
        typealias Function = ([WrappedValue.ArrayLiteralElement]) -> WrappedValue
        let initVariadic = unsafeBitCast(WrappedValue.init(arrayLiteral:), to: Function.self)
        self = Self(initVariadic(elements))
    }
}

extension Phantom: ExpressibleByBooleanLiteral where WrappedValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: WrappedValue.BooleanLiteralType) {
        self = Self(WrappedValue(booleanLiteral: value))
    }
}

extension Phantom: ExpressibleByDictionaryLiteral where WrappedValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (WrappedValue.Key, WrappedValue.Value)...) {
        typealias Function = ([(WrappedValue.Key, WrappedValue.Value)]) -> WrappedValue
        let initVariadic = unsafeBitCast(WrappedValue.init(dictionaryLiteral:), to: Function.self)
        self = Self(initVariadic(elements))
    }
}

extension Phantom: ExpressibleByExtendedGraphemeClusterLiteral where WrappedValue: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: WrappedValue.ExtendedGraphemeClusterLiteralType) {
        self = Self(WrappedValue(extendedGraphemeClusterLiteral: value))
    }
}

extension Phantom: ExpressibleByFloatLiteral where WrappedValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: WrappedValue.FloatLiteralType) {
        self = Self(WrappedValue(floatLiteral: value))
    }
}

extension Phantom: ExpressibleByIntegerLiteral where WrappedValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: WrappedValue.IntegerLiteralType) {
        self = Self(WrappedValue.init(integerLiteral: value))
    }
}

extension Phantom: ExpressibleByNilLiteral where WrappedValue: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = Self(WrappedValue(nilLiteral: nilLiteral))
    }
}

extension Phantom: ExpressibleByStringLiteral where WrappedValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = Self(WrappedValue(stringLiteral: value as! WrappedValue.StringLiteralType))
    }
}

extension Phantom: ExpressibleByUnicodeScalarLiteral where WrappedValue: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: WrappedValue.UnicodeScalarLiteralType) {
        self = Self(WrappedValue(unicodeScalarLiteral: value))
    }
}

extension Phantom: MonoidType where WrappedValue: MonoidType {
    public static var identity: Phantom<Context, WrappedValue> {
        Self(WrappedValue.identity)
    }

    public init() {
        self.init(WrappedValue.identity)
    }
}

extension Phantom: EmptiableType where WrappedValue: EmptiableType {
    public var isEmpty: Bool {
        wrappedValue.isEmpty
    }
}
