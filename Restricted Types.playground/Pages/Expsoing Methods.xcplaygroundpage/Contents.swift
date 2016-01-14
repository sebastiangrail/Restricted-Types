protocol Function {
    typealias In
    typealias Out
    
    static func apply (value: In) -> Out
}

struct And <A: Function, B: Function where A.In == B.In, A.Out == Bool, B.Out == Bool>: Function {
    static func apply(value: A.In) -> Bool {
        return A.apply(value) && B.apply(value)
    }
}

struct Subset <Predicate: Function where Predicate.Out == Bool> {
    typealias Superset = Predicate.In
    let value: Predicate.In
    
    init? (value: Predicate.In) {
        guard Predicate.apply(value) else {
            return nil
        }
        self.value = value
    }
    
    func tryPerform <Arg> (f: Superset -> Arg -> Superset, arg: Arg) -> Subset? {
        return Subset(value: f(value)(arg))
    }
    
    func apply <Result> (f: Superset -> Result) -> Result {
        return f(value)
    }
    
    func restrict <F: Function where F.In == Superset, F.Out == Bool> (predicate: F.Type) -> Subset<And<Predicate, F>>? {
        return Subset<And<Predicate, F>>(value: value)
    }
    
    func map <T, F: Function where F.In == T, F.Out == Bool> (transform: Superset -> T) -> Subset<F>? {
        return Subset<F>(value: transform(value))
    }
}

func nonMutating <T,U> (f: (inout T) -> U -> Void)(_ t: T)(_ u: U) -> T {
    var copy = t
    f(&copy)(u)
    return copy
}

/*
x: Subset<String> (p: String -> Bool)
f: String -> Int
y: Subset<Int) (p: Int -> Bool)

*/

//func f (x: String -> Bool, f: Int -> String) -> Int -> Bool {
//    
//}

struct IsNonEmptyString: Function {
    static func apply(value: String) -> Bool {
        return !value.isEmpty
    }
}

typealias NonEmptyString = Subset<IsNonEmptyString>

let greeting = NonEmptyString(value: "Hello World")!

print(greeting.value)

import Foundation

//let f = String.hasPrefix
let g = String.stringByAppendingString

greeting.tryPerform(String.stringByAppendingString, arg: "!")?.value

print(greeting.tryPerform(nonMutating(String.appendContentsOf), arg: "!")?.value)

struct S <Predicate: Function, Fallback: Function where Predicate.In == Fallback.In, Predicate.Out == Bool, Fallback.Out == Subset<Predicate>> {
    let value: Predicate.In
    
    init (value: Predicate.In) {
        if Predicate.apply(value) {
            self.value = value
        } else {
            self.value = Fallback.apply(value).value
        }
    }
}


struct ForceNonEmpty: Function {
    static func apply(value: String) -> Subset<IsNonEmptyString> {
        if let result = Subset<IsNonEmptyString>(value: value) {
            return result
        } else {
            return Subset<IsNonEmptyString>(value: "Default")!
        }
    }
}

typealias Foo = S<IsNonEmptyString, ForceNonEmpty>
print(Foo(value: "Hello").value)
print(Foo(value: "").value)

//struct S <F: Function, G: Function where F.Out == Bool, G.In == F.In, G.Out == Subset<F>> {
//    
//}

