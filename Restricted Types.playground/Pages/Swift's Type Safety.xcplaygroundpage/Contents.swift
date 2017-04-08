//: [Back to Introduction](Introduction)

//: # Swift's Type System

/*:
Swift has a very strict type system:
Given a function that takes an `Int`, we can only ever pass an `Int` as the argument
*/
func increase (_ n: Int) -> Int {
    return n + 1
}

increase(4) // compiles!

//: Trying to compile `increase("four")` will result in an error
//:
//: `cannot convert value of type 'String' to expected argument type 'Int'`


/*:
A type is a set of all values that inhibit the type.

- Swift's smallest type is `Void` and its only value is `()`
- `Bool` has two values: `true` and `false`.
- The type `String` is the infinite set of all unicode strings

Sometimes we need to work on subsets of these types, e.g. a non-empty `String`, or a `Double` between `0` and `1`.
Often this is done using runtime assertions:
*/

func sayHello (name: String) {
    assert(!name.isEmpty)
    print("Hello \(name)")
}

/*:
Functions like this are called 'partial', because they are only defined for a subset of the possible arguments.
Calling `sayHello("")` will lead to a crash at runtime. A function that is defined for all possible arguments is called "total".
To make a total function `sayHello` we need an argument that is a non-empty string.
We can create a new `struct` to represent such a subset:
*/

struct NonEmptyString {
    //: We use `String` to store our value
    let string: String
    
    //: The initialser only succeeds for non-empty `String`s
    init? (string: String) {
        guard !string.isEmpty else {
            return nil
        }
        self.string = string
    }
}

//: `NonEmptyString` is now guaranteed to only contain non-empty strings and we can now write a function that operates only on non-empty strings:

func sayHello (name: NonEmptyString) {
    print("Hello \(name.string)")
}

/*:
We could make similar types for uppercase strings and other subsets of `String`, but what if we want a non-empty, uppercase string?

In this playground we'll explore how to make creation of subset types simple and composable.
 */
