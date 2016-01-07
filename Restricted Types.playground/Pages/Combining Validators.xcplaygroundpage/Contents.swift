//: [Previous](@previous)

protocol ValidatorType {
    typealias Wrapped
    
    static func isValid (x: Wrapped) -> Bool
}

struct NonEmptyStringValidator: ValidatorType {
    typealias Wrapped = String
    
    static func isValid (x: Wrapped) -> Bool {
        return !x.isEmpty
    }
}

struct ValidatedString <Validator: ValidatorType> {
    
    let value: Validator.Wrapped
    
    init? (value: Validator.Wrapped) {
        guard Validator.isValid(value) else { return nil }
        self.value = value
    }
}

//: [Next](@next)
