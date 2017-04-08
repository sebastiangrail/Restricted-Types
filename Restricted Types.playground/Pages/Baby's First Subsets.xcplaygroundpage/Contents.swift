//: [Previous](@previous)

//* Let's start by looking at two subset types: `NonEmptyString` from the previous page and and `UppercaseString` (with a leading `_` to avoid naming conflicts with the better implementation :

struct _NonEmptyString {
    let string: String
    
    init? (string: String) {
        guard !string.isEmpty else {
            return nil
        }
        self.string = string
    }
}

struct _UppercaseString {
    let string: String
    
    init? (string: String) {
        guard string.uppercased() == string else {
            return nil
        }
        self.string = string
    }
}


/*:
There is a lot of repetition in these two types:

- A string value for storage
- A failable initialiser
- a `guard` with a predicate in the failable initialiser

Let's see how we can abstract these concepts. Remember that we need static guarantees, so we can't inject the the predicate at initialisation.
Instead we need a way to fix the predicate at compile time.
*/

protocol StringPredicate {
    static func isValid (_ string: String) -> Bool
}

struct StringSubset <P: StringPredicate> {
    let string: String
    
    init? (string: String) {
        guard P.isValid(string) else {
            return nil
        }
        self.string = string
    }
}

//: To implement a non-empty String and an uppercase String we now need custom predicates for those types:

struct IsNonEmptyString: StringPredicate {
    static func isValid(_ string: String) -> Bool {
        return !string.isEmpty
    }
}

struct IsUppercaseString: StringPredicate {
    static func isValid(_ string: String) -> Bool {
        return string.uppercased() == string
    }
}

//: The types are now simple `typealiases`:

typealias NonEmptyString = StringSubset<IsNonEmptyString>
typealias UppercaseString = StringSubset<IsUppercaseString>

NonEmptyString(string: "") // nil
NonEmptyString(string: "Hello World") // non-nil
UppercaseString(string: "not upper") // nil
UppercaseString(string: "UPPER")

//: [Next](@next)
