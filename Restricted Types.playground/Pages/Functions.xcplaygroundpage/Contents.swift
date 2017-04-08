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

struct And <A: Predicate, B: Predicate>: Predicate where A.Argument == B.Argument {
    static func isValid(_ value: A.Argument) -> Bool {
        return A.isValid(value) && B.isValid(value)
    }
}


struct Or <A: Predicate, B: Predicate>: Predicate where A.Argument == B.Argument {
    static func isValid(_ value: A.Argument) -> Bool {
        return A.isValid(value) || B.isValid(value)
    }
}

protocol StaticValue {
    associatedtype Value
    
    static var value: Value { get }
}

struct DoubleZero: StaticValue {
    static var value: Double { return 0 }
}

struct DoubleOne: StaticValue {
    static var value: Double { return 1 }
}

struct GreaterThan <V: StaticValue> : Predicate where V.Value: Comparable {
    static func isValid(_ value: V.Value) -> Bool {
        return value > V.value
    }
}

struct LesserThan <V: StaticValue> : Predicate where V.Value: Comparable {
    static func isValid(_ value: V.Value) -> Bool {
        return value < V.value
    }
}

struct EqualTo <V: StaticValue> : Predicate where V.Value: Equatable {
    static func isValid(_ value: V.Value) -> Bool {
        return value == V.value
    }
}


protocol Function {
    associatedtype In
    associatedtype Out
    
    static func apply (to value: In) -> Out
}

struct Characters: Function {
    static func apply (to value: String) -> String.CharacterView {
        return value.characters
    }
}

struct Count <C: Collection>: Function {
    static func apply (to value: C) -> C.IndexDistance {
        return value.count
    }
}

extension GreaterThan: Function {
    static func apply(to value: V.Value) -> Bool {
        return self.isValid(value)
    }
}

struct Compose <B: Function, A: Function>: Function where A.Out == B.In {
    static func apply(to value: A.In) -> B.Out {
        return B.apply(to: A.apply(to: value))
    }
}

struct Zero: StaticValue {
    static var value: Int { return 0 }
}

typealias StringLength = Compose<Count<String.CharacterView>, Characters>

let x = StringLength.apply(to: "asdf")

struct FunctionPredicate <F: Function>: Predicate where F.Out == Bool {
    static func isValid(_ value: F.In) -> Bool {
        return true
    }
}

protocol F {
    associatedtype In: StaticValue
    associatedtype Out: StaticValue
}



struct Add <A: StaticValue, B: StaticValue>: StaticValue where A.Value == Double, B.Value == Double {
    static var value: Double {
        return A.value + B.value
    }
}

typealias Two = Add<DoubleOne, DoubleOne>
typealias Four = Add<Two, Two>
Four.value

struct Apply <F: Function, A: StaticValue, B: StaticValue>: StaticValue where F.In == (A.Value, B.Value) {
    static var value: F.Out {
        return F.apply(to: (A.value, B.value))
    }
}

struct AddF: Function {
    typealias In = (Double, Double)
    typealias Out = Double
    
    static func apply(to value: In) -> Out {
        return value.0 + value.1
    }
}

typealias Two_ = Apply<AddF, DoubleOne, DoubleOne>
Two_.value

