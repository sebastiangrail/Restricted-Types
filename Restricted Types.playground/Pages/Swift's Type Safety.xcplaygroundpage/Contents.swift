//: Swift's Type System

//: Swift has a very strict type system:

//: Given a function that takes an `Int`, we can only ever pass in an `Int`
func increase (n: Int) -> Int {
    return n + 1
}


increase(4) // compiles!

//: Trying to compile `increase("four")` will result in an error
//:
//: `cannot convert value of type 'String' to expected argument type 'Int'`
// increase("four")

