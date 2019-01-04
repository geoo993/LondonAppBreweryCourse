//: Playground - noun: a place where people can play

// https://moduscreate.com/blog/classes-and-structs-in-swift/
// http://net-informations.com/faq/oops/struct.htm


/*
 Classes:
 - Can support inheritance
 - Are reference (pointer) types
 - Allow reference counting for multiple references
 - The reference can be null
 - Have memory overhead per new instance
 - Must declare initialiser (constructer)
 - Has deinitialisers
 - Allows Type casting

 Structs:
 - Cannot support inheritance
 - Are value types
 - Are passed by value (like integers)
 - Cannot have a null reference (unless Nullable is used)
 - Do not have a memory overhead per new instance - unless 'boxed'
 - Don’t have deinitialiser

 Classes and Structs:
 - Are compound data types typically used to contain a few variables that have some logical relationship
 - Can contain methods and events
 - Can support interfaces
 - Define properties to store values
 - Define methods to provide functionality
 - Be extended
 - Conform to protocols
 - Define initialisers
 - Define Subscripts to provide access to their variables

 */

/*
With the introduction of Swift, native iOS development has become more approachable and modern. Classes and structs in Swift are basic constructs of your program. In Swift, both classes and structs can have properties and functions. The key difference is structs are value types and classes are reference types. Because of this, let and var behave differently with structs and classes.

 */

 // Using let on a struct makes that object a constant.
 // It cannot be changed or reassigned and neither can its variables. A struct created as a var can have its variables changed.
struct Dog {
    var name: String
    var breed: String
    var age: Int
    var beenFed: Bool

    init(name: String, breed: String, age: Int) {
        self.name = name
        self.breed = breed
        self.age = age
        self.beenFed = false
    }

}

var milo = Dog(name: "Milo", breed: "Chihuahua", age: 3)

var meg = Dog(name: "Meg", breed: "Beagle", age: 5)
meg.name = "Lucy"



// Since classes are reference objects the only difference between let and var is the ability to reassign
// the variable to a different class of the same type. The let and var keywords do not affect the ability
// to change a variable on a class.


class Car {
    var model: String
    var make: String
    var year: Int

    init(model: String, make: String, year: Int) {
        self.model = model
        self.make = make
        self.year = year
    }
}

let juliasCar = Car(model: "C400", make: "Mercedes-Benz", year: 2015)
juliasCar.model = "C450" // okay because classes can always have variables changed
//juliasCar = Car(model: "C550", make: "Mercedes-Benz", year: 2016) // Compile-time error
var shellisCar = Car(model: "RS7", make: "Audi", year: 2015)
shellisCar = Car(model: "R8", make: "Audi", year: 2016)


// Functions marked as mutating change internal property values. Mutating functions are only present
// on structs and can only be used on structs created as a var.
struct Fruit {
    var type: String
    var eaten: Bool

    init(type: String) {
        self.type = type
        self.eaten = false
    }

    mutating func eat() {
        eaten = true
    }
}

let apple = Fruit(type: "apple")
//apple.eat() // Compile-time error
var orange = Fruit(type: "orange")
orange.eat() // No issues



// Since structs are value types, they are pass by value.
// This means their contents will be copied when passed into functions.
// A struct variable can be marked as an inout parameter if it needs to be modified
// inside a function and its value persisted outside of the scope of the function.
func feedDog(dog: inout Dog) {
    dog.beenFed = true
}
feedDog(dog: &milo) // Using the & passes a struct as a reference
print(milo.beenFed) // prints out true


/* FINAL Thought
In Swift structs and classes give you both value and reference-based constructs for your objects. Structs are preferred for objects designed for data storage like Array. Structs also help remove memory issues when passing objects in a multithreaded environment. Classes, unlike structs, support inheritance and are used more for containing logic like UIViewController. Most standard library data objects in Swift, like String, Array, Dictionary, Int, Float, Boolean, are all structs, therefore value objects. The mutability of var versus let is why in Swift there are no mutable and non-mutable versions of collections like Objective C’s NSArray and NSMutableArray.
 */
