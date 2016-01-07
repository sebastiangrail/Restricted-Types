//: [Previous](@previous)

struct NonEmptyString {
    let string: String
    
    init? (string: String) {
        guard !string.isEmpty else {
            return nil
        }
        self.string = string
    }
}

//: Impossible to create an instance of `NonEmptyString` that contains an empty string.

struct UppercaseString {
    let string: String
    
    init? (string: String) {
        guard string.uppercaseString == string else {
            return nil
        }
        self.string = string
    }
}

//: Impossible to create a lowercase string value of type `UppercaseString`

//: Two problems: Methods calls on underlying types and type composition

struct UpTo8CharactersString {
    let string: String
    
    init? (string: String) {
        guard string.characters.count <= 8 else {
            return nil
        }
        self.string = string
    }
}




//extension UpTo8CharactersString {
//    func appendContentsOf (other: String) -> UpTo8CharactersString? {
//        return UpTo8CharactersString(string: string + other)
//    }
//}

/*: Problem 1: Call methods on string

What do methods on `String` look like?

e.g.: `appendContentsOf`

    appendContentsOf: String -> String -> String

*/

//: [Next](@next)
