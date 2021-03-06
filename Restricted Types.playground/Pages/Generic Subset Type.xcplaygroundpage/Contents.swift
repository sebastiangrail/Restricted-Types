//: [Previous](@previous)

//: The protocol on the previous page was fixed to `String`s. It's easy to make it generic


protocol Predicate {
    associatedtype Argument
    
    static func isValid (_ value: Argument) -> Bool
}

//: In the `Subset` type we can now replace occurences of `String` with `P.Argument` and rename the stored property to `value`

struct Subset <P: Predicate> {
    let value: P.Argument
    
    init? (value: P.Argument) {
        guard P.isValid(value) else {
            return nil
        }
        self.value = value
    }
}

//: The implementations for `IsNonEmptyString` and `IsUppercaseString` stay almost the same, the `typealias` from the protocol can be inferred

struct IsNonEmptyString: Predicate {
    static func isValid(_ value: String) -> Bool {
        return !value.isEmpty
    }
}

struct IsUppercaseString: Predicate {
    static func isValid(_ value: String) -> Bool {
        return value.uppercased() == value
    }
}

typealias NonEmptyString = Subset<IsNonEmptyString>
typealias UppercaseString = Subset<IsUppercaseString>


//: We can now make subsets of our types:

struct IsPositiveDouble: Predicate {
    static func isValid(_ value: Double) -> Bool {
        return value > 0
    }
}
typealias PositiveDouble = Subset<IsPositiveDouble>

struct IsNonEmptySequence <S: Sequence>: Predicate {
    static func isValid(_ value: S) -> Bool {
        return true
    }
}
typealias NonEmptyIntArray = Subset<IsNonEmptySequence<Array<Int>>>






//: [Next](@next)
