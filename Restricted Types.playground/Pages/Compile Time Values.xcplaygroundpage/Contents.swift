
protocol Predicate {
    associatedtype Argument
    
    static func isValid (_ value: Argument) -> Bool
}

struct Subset <P: Predicate> {
    let value: P.Argument
    
    init? (value: P.Argument) {
        guard P.isValid(value) else {
            return nil
        }
        self.value = value
    }
}

struct And <A: Predicate, B: Predicate>: Predicate where A.Argument == B.Argument {
    static func isValid(_ value: A.Argument) -> Bool {
        return A.isValid(value) && B.isValid(value)
    }
}


struct Or <A: Predicate, B: Predicate>: Predicate where A.Argument == B.Argument {
    static func isValid(_ value: A.Argument) -> Bool {
        return A.isValid(value) || B.isValid(value)
    }
}

protocol StaticValue {
    associatedtype Value
    
    static var value: Value { get }
}

struct DoubleZero: StaticValue {
    static var value: Double { return 0 }
}

struct DoubleOne: StaticValue {
    static var value: Double { return 1 }
}

struct GreaterThan <V: StaticValue> : Predicate where V.Value: Comparable {
    static func isValid(_ value: V.Value) -> Bool {
        return value > V.value
    }
}

struct LesserThan <V: StaticValue> : Predicate where V.Value: Comparable {
    static func isValid(_ value: V.Value) -> Bool {
        return value < V.value
    }
}

struct EqualTo <V: StaticValue> : Predicate where V.Value: Equatable {
    static func isValid(_ value: V.Value) -> Bool {
        return value == V.value
    }
}

typealias PositiveDouble = Subset<GreaterThan<DoubleZero>>

PositiveDouble(value: 0)
PositiveDouble(value: -1)
PositiveDouble(value: 1)

typealias IsGreaterOrEqualToZero = Or<EqualTo<DoubleZero>, GreaterThan<DoubleZero>>
typealias IsLesserThanOrEqualToOne = Or<EqualTo<DoubleOne>, LesserThan<DoubleOne>>

typealias DoubleZeroToOne = Subset<And<IsGreaterOrEqualToZero, IsLesserThanOrEqualToOne>>

DoubleZeroToOne(value: -0.001)
DoubleZeroToOne(value: 0)
DoubleZeroToOne(value: 0.5)
DoubleZeroToOne(value: 1)
DoubleZeroToOne(value: 1.1)



