//: Playground - noun: a place where people can play

// https://softwareengineering.stackexchange.com/questions/285333/how-does-garbage-collection-compare-to-reference-counting
// https://stackoverflow.com/questions/24019009/memory-is-managed-automatically-how
// https://stackoverflow.com/questions/6385212/how-does-the-new-automatic-reference-counting-mechanism-work
// https://flyingfrogblog.blogspot.com/2017/12/does-reference-counting-really-use-less.html


//// Why would anyone use garbage collection

/* BY: ALXGTV

 To understand how the two approaches compare we need to first examine how they work and the weaknesses of each.

 Automatic Reference counting or ARC, is a form of garbage collection in which objects are deallocated once there are no more references to them, i.e. no other variable refers to the object in particular. Each object, under ARC, contains a reference counter, stored as an extra field in memory, which is incremented every time you set a variable to that object (i.e. a new reference to the object is created), and is decremented every time you set a reference to the object to nil/null, or a reference goes out of scope (i.e. it is deleted when the stack unwinds), once the reference counter goes down to zero, the object takes care of deleting itself, calling the destructor and freeing the allocated memory. This approach has a significant weakness, as we shall see below.

 "There's no need to worry about memory management because it's all taken care of for you by reference counting," that's actually a misconception you still do need to take care to avoid certain conditions, namely circular references, in order for ARC to function correctly. A circular reference is when an object A holds a strong reference to an object B, which itself holds a strong reference to the same object A, in this situation neither object is going to be deallocated because in order for A to be deallocated its reference counter must be decremented to zero, but at least one of those references is object B, for object B to be deallocated, its reference counter must also be decremented to 0, but at least one of those references is object A, can you see the problem? ARC solves this by allowing the programmer to give compiler hints about how different object references should be treated, there are two types of references: strong references and weak references. Strong references are, as I mentioned above, a type of reference which prolongs the life of the referenced object (increments its reference counter), weak references are a type of reference which does not prolong the life of an object (that is, it does not increment the object's reference counter), but that would mean the referenced object could get deallocated and you'd would be left with an invalid reference pointing to junk memory. In order for this situation to be avoided, the weak reference is set to a safe value (e.g. nil in Objective-C) once the object is deallocated, thus the object has an extra responsibility of keeping track of all weak references and setting them to a safe value once it deletes itself. Weak references are usually used in a child-parent object relation, the parent holds a strong reference to all it's child objects, whereas the child objects hold a weak reference to the parent, the rationale being that in most cases if you no longer care about the parent object, you most likely no longer care about the child objects either.

 Tracing garbage collection (i.e. what is most often referred to as simply garbage collection) involves keeping a list of all root objects (i.e. those stored in global variables, the local variables of the main procedure, etc) and tracing which objects are reachable (marking each object encountered) from those root objects. Once the garbage collector has gone through all the objects referenced by the root objects, the GC now goes through every allocated object, if it is marked as reachable it stays in memory, if it is not marked as reachable it is deallocated, this is known as the mark-and-sweep algorithm. This has the advantage of not suffering from the circular reference problem as: if neither the mutually referenced object A and object B are referenced by any other object reachable from the root objects, neither object A nor object B are marked as reachable and are both deallocated. Tracing garbage collectors run in certain intervals pausing all threads, which can lead to inconsistent performance (sporadic pauses). The algorithm described here is a very basic description, modern GC's are usually much more advanced using an object generation system, tri-color sets etc, and also perform other tasks such as defragmentation of the program's memory space by moving the objects to a contiguous storage space, this is the reason why GC'ed languages such as C# and Java do not allow pointers. One significant weakness of tracing garbage collectors is that class destructors are no longer deterministic, that is the programmer cannot tell when an object is going to be garbage collected in-fact GC'ed languages do not even allow the programmer to specify a class destructor, thus classes can no longer be used to encapsulate the management of resources such as file handles, database connections, etc. The responsibility is left on the programmer to close open files, database connections manually, hence why languages such as Java have a finally keyword (in the try,catch block) to make sure the cleanup code is always executed before the stack unwinds, whereas in C++ (no GC) such resources are handled by a wrapper object (allocated on the stack) which acquires the resource in the constructor and releases it in the destructor, which is always called as the object is removed from the stack.

 As for performance, both have performance penalties. Automatic reference counting delivers a more consistent performance, no pauses, but slows down your application as a whole as every assignment of an object to a variable, every deallocation of an object, etc, will need an associated incrementation/decrementation of the reference counter, and taking care of reassigning the weak references and calling each destructor of each object being deallocated. GC does not have the performance penalty of ARC when dealing with object references; however, it incurs pauses while it is collecting garbage (rendering unusable for real-time processing systems) and requires a large memory space in order for it to function effectively such that it is not forced to run, thus pausing execution, too often.

 As you can see both have their own advantages and disadvantages, there is no clear cut ARC is better or GC is better, both are compromises.

 PS: ARC also becomes problematic when objects are shared across multiple threads requiring atomic incrementation/decrementation of the reference counter, which itself presents a whole new array of complexities and problems. This should answer your question as to "why would anyone use garbage collection".
 */

/* BY gnasher729
 With garbage collection, the problem is that you may still have left some reference to an object around somewhere. There was a case where an early self-driving vehicle crashed because references to information about previous locations were stored in an array and never became garbage, so after 45 minutes it ran out of memory and crashed. I think not literally, it stopped driving, but it might have crashed as well.

 With reference counting, the problem is that you may have cyclic references A->B->A or A->B->C->...->Z->A, and no reference count ever goes to zero. That's why you have weak references and you need to know when to use them.

 Both ways, you need to understand how things work, or you will get into trouble. Performance wise, if you ask Java developers they say garbage collection is faster; if you ask say Objective-C developers they say reference counting is faster. Studies prove what they want to prove. If it makes a difference, you should reduce the number of allocations, not switch languages.

 You also need to know about weak references, basically a reference to an object that doesn't keep the object alive. And you need to know what happens exactly once it has been decided that an object should be thrown out; in Java I think there are ways how an object could become alive again, in Objective-C / Swift once the reference count is zero, that object is going to go away no matter what you try to hold on to it.
 */

/*
 Manual memory management, reference counting, and garbage collection all have their pro's and con's:

 - Manual memory management: Unbeatable fast, but prone to bugs due to errors in freeing the memory. Also, oftentimes you will need to implement at least reference counting on top of manual memory management yourself when you get several objects that all require a single object to remain alive.

 - Reference counting: Small overhead (incrementing/decrementing a counter and a zero check is not that expensive), allows easy management of quite complex data structures, where every object may be referenced by several others. The deficiency is that reference counting requires references not to be circular. Once you get reference circles, you leak memory.

    Weak references may be used to break some reference cycles, however, they come with quite a bit of additional costs:

    1) Weak references require a second reference count to manage the weak reference itself. Likely, the weak reference is another object that needs to be allocated independently, incurring a significant overhead in memory consumption.

    2) Destroying an object in the presence of weak references requires atomically resetting the weak reference that belongs to the object and decrementing the reference count. Otherwise you get erratic behavior of the weak references. I'm not into the details, but I believe this can be hard to achieve in a lock-free fashion.
    This can all be done, but it's not as simple as reference counting without weak references.

 - Garbage collection: Can cope with all possible dependency graphs, but has quite severe performance impact. After all, the garbage collector has to prove somehow that an object is not reachable anymore before it can collect it. Modern garbage collectors are quite good at avoiding long lags while they do their work, but the work needs to be done somehow. This is especially bad for real-time applications that need to guarantee a response within a given time frame.

 */

/*

    Swift uses ARC in a similar way as Objective-C does.

    In short:
    - There is no garbage collector.
    - Objects live as long as (strong) references exist.
    - Strong references can't be cyclic, otherwise you leak memory. Use weak references to break cycles.

    But more specifically ARC works by doing exactly what you would do with your code (with certain minor differences). ARC is a compile time technology, unlike GC which is runtime and will impact your performance negatively. ARC will track the references to objects for you and synthesize the retain/release/autorelease methods according to the normal rules. Because of this ARC can also release things as soon as they are no longer needed, rather than throwing them into an autorelease pool purely for convention sake.

    Every time you create a new instance of a class, ARC allocates a chunk of memory to store information about that instance. This memory holds information about the type of the instance, together with the values of any stored properties associated with that instance.

    Additionally, when an instance is no longer needed, ARC frees up the memory used by that instance so that the memory can be used for other purposes instead. This ensures that class instances do not take up space in memory when they are no longer needed.

    However, if ARC were to deallocate an instance that was still in use, it would no longer be possible to access that instance’s properties, or call that instance’s methods. Indeed, if you tried to access the instance, your app would most likely crash.

    To make sure that instances don’t disappear while they are still needed, ARC tracks how many properties, constants, and variables are currently referring to each class instance. ARC will not deallocate an instance as long as at least one active reference to that instance still exists.

    To make this possible, whenever you assign a class instance to a property, constant, or variable, that property, constant, or variable makes a strong reference to the instance. The reference is called a “strong“ reference because it keeps a firm hold on that instance, and does not allow it to be deallocated for as long as that strong reference remains.
 */


import Foundation

enum Expr {
    case Integer(n: Int)
    case Variable(x: String)
    indirect case Add(f: Expr, g: Expr)
    indirect case Mul(f: Expr, g: Expr)
    indirect case Pow(f: Expr, g: Expr)
    indirect case Ln(f: Expr)
}

func pown(a: Int, b: Int) -> Int {
    switch (b) {
    case 0 : return 1
    case 1 : return a
    case let n :
        let b = pown(a: a, b: n / 2)
        return b * b * (n % 2 == 0 ? 1 : a)
    }
}

func add(f: Expr, g: Expr) -> Expr {
    switch (f, g) {
    case (let .Integer(n: m), let .Integer(n: n)) : return .Integer(n: m + n)
    case (.Integer(n: 0), let f) : return f
    case (let f, .Integer(n: 0)) : return f
    case (let f, let .Integer(n: n)) : return add(f: .Integer(n: n), g: f)
    case (let f, let .Add(.Integer(n: n), g)) : return add(f: .Integer(n: n), g: add(f: f, g: g))
    case (let .Add(f, g), let h) : return add(f: f, g: add(f: g, g: h))
    case (let f, let g) : return .Add(f: f, g: g)
    }
}

func mul(f: Expr, g: Expr) -> Expr {
    switch (f, g) {
    case (let .Integer(n: m), let .Integer(n: n)) : return .Integer(n: m * n)
    case (.Integer(n: 0), _) : return .Integer(n: 0)
    case (_, .Integer(n: 0)) : return .Integer(n: 0)
    case (.Integer(n: 1), let f) : return f
    case (let f, .Integer(n: 1)) : return f
    case (let f, let .Integer(n: n)) : return mul(f: .Integer(n: n), g: f)
    case (let f, let .Mul(.Integer(n: n), g)) : return mul(f: .Integer(n: n), g: mul(f: f, g: g))
    case (let .Mul(f: f, g: g), let h) : return mul(f: f, g: mul(f: g, g: h))
    case (let f, let g) : return .Mul(f: f, g: g)
    }
}

func pow(f: Expr, g: Expr) -> Expr {
    switch (f, g) {
    case (let .Integer(n: m), let .Integer(n: n)) : return .Integer(n: pown(a: m, b: n))
    case (_, .Integer(n: 0)) : return .Integer(n: 1)
    case (let f, .Integer(n: 1)) : return f
    case (.Integer(n: 0), _) : return .Integer(n: 0)
    case (let f, let g) : return .Pow(f: f, g: g)
    }
}

func ln(f: Expr) -> Expr {
    switch (f) {
    case .Integer(n: 1) : return .Integer(n: 0)
    case let f : return .Ln(f: f)
    }
}

func d(x: String, f: Expr) -> Expr {
    switch (f) {
    case .Integer(n: _) : return .Integer(n: 0)
    case let .Variable(x: y) : if x == y { return .Integer(n: 1) } else { return .Integer(n: 0) }
    case let .Add(f: f, g: g) : return add(f: d(x: x, f: f), g: d(x: x, f: g))
    case let .Mul(f: f, g: g) : return add(f: mul(f: f, g: d(x: x, f: g)), g: mul(f: g, g: d(x: x, f: f)))
    case let .Pow(f: f, g: g) : return mul(f: pow(f: f, g: g), g: add(f: mul(f: mul(f: g, g: d(x: x, f: f)), g: pow(f: f, g: .Integer(n: -1))), g: mul(f: ln(f: f), g: d(x: x, f: g))))
    case let .Ln(f: f) : return mul(f: d(x: x, f: f), g: pow(f: f, g: .Integer(n: -1)))
    }
}

func count(f: Expr) -> Int {
    switch (f) {
    case .Integer(n: _) : return 1
    case .Variable(x: _) : return 1
    case let .Add(f: f, g: g) : return count(f: f) + count(f: g)
    case let .Mul(f: f, g: g) : return count(f: f) + count(f: g)
    case let .Pow(f: f, g: g) : return count(f: f) + count(f: g)
    case let .Ln(f: f) : return count(f: f)
    }
}

func stringOfExpr(f: Expr) -> String {
    switch (f) {
    case let .Integer(n: n) : return String(n)
    case let .Variable(x: x) : return x
    case let .Add(f: f, g: g) : return "(" + stringOfExpr(f: f) + " + " + stringOfExpr(f: g) + ")"
    case let .Mul(f: f, g: g) : return "(" + stringOfExpr(f: f) + " * " + stringOfExpr(f: g) + ")"
    case let .Pow(f: f, g: g) : return "(" + stringOfExpr(f: f) + "^" + stringOfExpr(f: g) + ")"
    case let .Ln(f: f) : return "ln(" + stringOfExpr(f: f) + ")"
    }
}

func stringOf(f: Expr) -> String {
    let n = count(f: f)
    if n > 100 {
        return "<<" + String(n) + ">>"
    } else {
        return stringOfExpr(f: f)
    }
}

let x = Expr.Variable(x: "x")

let f = pow(f: x, g: x)

func nest(n: Int, f: ((Expr) -> Expr), x: Expr) -> Expr {
    if n == 0 { return x } else {
        return nest(n: n-1, f: f, x: f(x))
    }
}

var dx = { (f: Expr) -> Expr in
    let df = d(x: "x", f: f)
    print("D(" + stringOf(f: f) + ") = " + stringOf(f: df))
    return df
}

//var n = Int(n: CommandLine.arguments[1])
//print(count(f: nest(n: n!, f: dx, x: f)))

print(count(f: nest(n: 5, f: dx, x: f)))
