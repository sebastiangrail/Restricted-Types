//: What if we want a non-empty uppercase string? Is there a way to compose the predicates?

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


struct And <A: Predicate, B: Predicate>: Predicate where A.Argument == B.Argument {
    static func isValid(_ value: A.Argument) -> Bool {
        return A.isValid(value) && B.isValid(value)
    }
}

typealias NonEmptyUppercaseString = Subset<And<IsNonEmptyString, IsUppercaseString>>

let a = NonEmptyUppercaseString(value: "")
let b = NonEmptyUppercaseString(value: "foo")
let c = NonEmptyUppercaseString(value: "FOO")


struct Or <A: Predicate, B: Predicate>: Predicate where A.Argument == B.Argument {
    static func isValid(_ value: A.Argument) -> Bool {
        return A.isValid(value) || B.isValid(value)
    }
}
