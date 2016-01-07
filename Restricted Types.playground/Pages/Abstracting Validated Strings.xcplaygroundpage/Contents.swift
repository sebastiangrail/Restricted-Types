//: [Previous](@previous)



/*: Common Elements:

- Wrapped Type
- Predicate from wrapped type to Bool
- Failable initaliser taking wrapped type using predicate

*/

protocol StringValidatorType {
    static func isValid (x: String) -> Bool
}

struct UppercaseStringValidator: StringValidatorType {
    static func isValid (x: String) -> Bool {
        return x.uppercaseString == x
    }
}

struct NonEmptyStringValidator: StringValidatorType {
    static func isValid (x: String) -> Bool {
        return !x.isEmpty
    }
}

struct ValidatedString <Validator: StringValidatorType> {
    let value: String
    
    init? (value: String) {
        guard Validator.isValid(value) else { return nil }
        self.value = value
    }
}



//: [Next](@next)
