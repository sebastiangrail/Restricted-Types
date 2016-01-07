//: [Previous](@previous)

//: ## Partial Functions

//: A partial function is a function `T -> U` that is only defined on a subset of all values of `T`

//: For example integer division by zero is not defined
func divideBy (x: Int, by: Int) -> Int {
    return x/by
}

divideBy(4, by: 2)
//: Returns `2`

//: `divideBy(4, by: 0)` compiles, but crashes at runtime


//: Many methods in Objective-C Cocoa are partial, they are not defined for `nil` values.
//: Swift's optional type is a big improvement and most APIs are now properly annotated.

/*: But there are other methods that are partial:

`CKAsset.init(fileURL fileURL: NSURL)` expects a file URL

// TODO: More examples
*/


/*: Often the types are too generic. A String is often not an appropriate type.

*/

//: [Next](@next)
