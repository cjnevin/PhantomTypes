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

// MARK: - Monoid

public protocol MonoidType {
    static var identity: Self { get }
}

extension Phantom: MonoidType where WrappedValue: MonoidType {
    public static var identity: Phantom<Context, WrappedValue> {
        Self(WrappedValue.identity)
    }

    public init() {
        self.init(WrappedValue.identity)
    }
}

extension String: MonoidType {
    public static var identity: String = ""
}

extension Int: MonoidType {
    public static var identity: Int = 0
}

extension Float: MonoidType {
    public static var identity: Float = 0
}

extension Double: MonoidType {
    public static var identity: Double = 0
}

extension Array: MonoidType {
    public static var identity: Array<Element> { [] }
}

extension Dictionary: MonoidType {
    public static var identity: Dictionary<Key, Value> { [:] }
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

// MARK: - Property Wrappers

public protocol WrappedType {
    associatedtype WrappedValue
    var wrappedValue: WrappedValue { get set }
}

@propertyWrapper
public struct Restrict<T: WrappedType> {
    public var wrappedValue: T {
        didSet { restrict(&wrappedValue) }
    }
    private let restrict: (inout T) -> Void
    public init(_ wrappedValue: T, _ restrict: @escaping (inout T) -> Void) {
        self.wrappedValue = wrappedValue
        self.restrict = restrict
        self.restrict(&self.wrappedValue)
    }
}

extension Restrict where T: MonoidType {
    public init(_ restrict: @escaping (inout T) -> Void) {
        self.init(T.identity, restrict)
    }
}

@propertyWrapper
public struct WithinRange<T: WrappedType> where T.WrappedValue: Numeric, T.WrappedValue: Comparable {
    public var wrappedValue: T {
        get { restriction.wrappedValue }
        set { restriction.wrappedValue = newValue }
    }
    private var restriction: Restrict<T>

    public init(_ wrappedValue: T, _ range: ClosedRange<T.WrappedValue>) {
        restriction = .init(wrappedValue) {
            $0.wrappedValue = min(range.upperBound, max(range.lowerBound, $0.wrappedValue))
        }
    }
}

extension WithinRange where T: MonoidType {
    public init(_ range: ClosedRange<T.WrappedValue>) {
        self.init(T.identity, range)
    }
}

@propertyWrapper
public struct Truncated<T: WrappedType> where T.WrappedValue: RangeReplaceableCollection {
    public var wrappedValue: T {
        get { restriction.wrappedValue }
        set { restriction.wrappedValue = newValue }
    }
    private var restriction: Restrict<T>

    public init(_ wrappedValue: T, maxLength: Int) {
        restriction = .init(wrappedValue) {
            $0.wrappedValue = T.WrappedValue($0.wrappedValue.prefix(maxLength))
        }
    }
}

extension Truncated where T: MonoidType {
    public init(maxLength: Int) {
        self.init(T.identity, maxLength: maxLength)
    }
}
