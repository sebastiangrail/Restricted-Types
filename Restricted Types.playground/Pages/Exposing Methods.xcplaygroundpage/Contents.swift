protocol Function {
    associatedtype In
    associatedtype Out
    
    static func apply (to value: In) -> Out
}

struct And <A: Function, B: Function>: Function where A.In == B.In, A.Out == Bool, B.Out == Bool {
    static func apply(to value: A.In) -> Bool {
        return A.apply(to: value) && B.apply(to: value)
    }
}

struct Subset <Predicate: Function> where Predicate.Out == Bool {
    typealias Superset = Predicate.In
    let value: Predicate.In
    
    init? (value: Predicate.In) {
        guard Predicate.apply(to: value) else {
            return nil
        }
        self.value = value
    }
    
    func tryPerform <Arg> (_ f: (Superset) -> (Arg) -> Superset, arg: Arg) -> Subset? {
        return Subset(value: f(value)(arg))
    }
    
    func apply <Result> (f: (Superset) -> Result) -> Result {
        return f(value)
    }
    
    func restrict <F: Function> (predicate: F.Type) -> Subset<And<Predicate, F>>? where F.In == Superset, F.Out == Bool {
        return Subset<And<Predicate, F>>(value: value)
    }
    
    func map <T, F: Function> (transform: (Superset) -> T) -> Subset<F>? where F.In == T, F.Out == Bool {
        return Subset<F>(value: transform(value))
    }
}

func nonMutating <T,U> (_ f: @escaping (inout T) -> (U) -> Void) -> (T) -> (U) -> T {
    return { t in
        return { u in
            var copy = t
            f(&copy)(u)
            return copy
        }
    }
    
}

struct IsNonEmptyString: Function {
    static func apply(to value: String) -> Bool {
        return !value.isEmpty
    }
}

typealias NonEmptyString = Subset<IsNonEmptyString>

let greeting = NonEmptyString(value: "Hello World")!

print(greeting.value)

import Foundation

//let f = String.hasPrefix
//let g = String.appending

greeting.tryPerform(String.appending, arg: "!")?.value

print(greeting.tryPerform(nonMutating(String.append), arg: "!")?.value as Any)

struct S <Predicate: Function, Fallback: Function> where Predicate.In == Fallback.In, Predicate.Out == Bool, Fallback.Out == Subset<Predicate> {
    let value: Predicate.In
    
    init (value: Predicate.In) {
        
        if Predicate.apply(to: value) {
            self.value = value
        } else {
            self.value = Fallback.apply(to: value).value
        }
    }
}


struct ForceNonEmpty: Function {
    static func apply(to value: String) -> Subset<IsNonEmptyString> {
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

