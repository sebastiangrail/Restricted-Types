protocol Predicate {
    typealias Argument
    
    static func isValid (value: Argument) -> Bool
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

struct And <A: Predicate, B: Predicate where A.Argument == B.Argument>: Predicate {
    static func isValid(value: A.Argument) -> Bool {
        return A.isValid(value) && B.isValid(value)
    }
}


struct Or <A: Predicate, B: Predicate where A.Argument == B.Argument>: Predicate {
    static func isValid(value: A.Argument) -> Bool {
        return A.isValid(value) || B.isValid(value)
    }
}

protocol StaticValue {
    typealias Value
    
    static var value: Value { get }
}

struct DoubleZero: StaticValue {
    static var value: Double { return 0 }
}

struct DoubleOne: StaticValue {
    static var value: Double { return 1 }
}

struct GreaterThan <V: StaticValue where V.Value: Comparable> : Predicate {
    static func isValid(value: V.Value) -> Bool {
        return value > V.value
    }
}

struct LesserThan <V: StaticValue where V.Value: Comparable> : Predicate {
    static func isValid(value: V.Value) -> Bool {
        return value < V.value
    }
}

struct EqualTo <V: StaticValue where V.Value: Equatable> : Predicate {
    static func isValid(value: V.Value) -> Bool {
        return value == V.value
    }
}


protocol Function {
    typealias In
    typealias Out
    
    static func apply (value: In) -> Out
}

struct Characters: Function {
    static func apply (value: String) -> String.CharacterView {
        return value.characters
    }
}

struct Count <C: CollectionType>: Function {
    static func apply (value: C) -> C.Index.Distance {
        return value.count
    }
}

extension GreaterThan: Function {
    static func apply(value: V.Value) -> Bool {
        return self.isValid(value)
    }
}

struct Compose <B: Function, A: Function where A.Out == B.In>: Function {
    static func apply(value: A.In) -> B.Out {
        return B.apply(A.apply(value))
    }
}

struct Zero: StaticValue {
    static var value: Int { return 0 }
}

typealias StringLength = Compose<Count<String.CharacterView>, Characters>

let x = StringLength.apply("asdf")

struct FunctionPredicate <F: Function where F.Out == Bool>: Predicate {
    static func isValid(value: F.In) -> Bool {
        return true
    }
}

protocol F {
    typealias In: StaticValue
    typealias Out: StaticValue
}



struct Add <A: StaticValue, B: StaticValue where A.Value == Double, B.Value == Double>: StaticValue {
    static var value: Double {
        return A.value + B.value
    }
}

typealias Two = Add<DoubleOne, DoubleOne>
typealias Four = Add<Two, Two>
Four.value

struct Apply <F: Function, A: StaticValue, B: StaticValue where F.In == (A.Value, B.Value)>: StaticValue {
    static var value: F.Out {
        return F.apply((A.value, B.value))
    }
}

struct AddF: Function {
    typealias In = (Double, Double)
    typealias Out = Double
    
    static func apply(value: In) -> Out {
        return value.0 + value.1
    }
}

typealias Two_ = Apply<AddF, DoubleOne, DoubleOne>
Two_.value

