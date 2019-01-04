//: Playground - noun: a place where people can play

// https://medium.com/@itchyankles/memory-management-in-rust-and-swift-8ecda3cdf5b7

/* Memory Allocation

 Generally, when we allocate memory in our programs there are 3 places it can live.

 Static Memory:
     First, memory can be statically allocated, living inside our program’s binary, never changing as the program runs.
     Static memory isn’t actually “allocated” at run time.
     Instead it moves into memory with our program’s code before the program is even run avoiding any runtime cost of allocation.
     Static strings and constants in Swift are examples of statically allocated memory.

 Stack Allocated Memory:
     Second, memory can be stack allocated.
     The stack is the data structure responsible for holding information about active subroutines or functions.
     The stack sits at the top of memory and is usually used for data that has a size known at compile time.
     For example, in many languages integers are stack allocated while strings are not.
     This is because it’s always possible to know how much memory needs to be allocated to represent a number,
     but it is not always possible to know how much memory is needed to represent a string.
     The string can be as short as a “” and as long as Moby Dick or even longer!

     When a function is called we allocate memory on the stack by moving the stack pointer
     (the CPU register pointing to the top of the stack) “up” however many bytes we need for all stack allocated local variables.
     This approach is very efficient as it’s usually done with only one assembly instruction.
     Say we know that we have 4 local variables all of which are 4 bytes big.
     That means all we need to do is add 16 (4 x 4 bytes) to the stack pointer. That’s something the CPU is born to do!

     Many times “stack allocated” variables aren’t actually kept on the stack but rather in CPU
     registers so manipulating them doesn’t even require memory access making their use even faster.

     In Swift value types such as ints, floats and structs are stack allocated while reference types
     such as classes and closures are “heap” allocated.
     Using value types in Swift can be much more efficient than reference types because stack allocation
     is much cheaper than heap allocation. After all, you can’t get much more efficient than adding two numbers together.

     Swift copyies stack allocated data each time a new reference is made to it
     (e.g. when we pass it to a function or bind it to a new variable).

 Heap Allocated Memory:
    Lastly, memory can be heap allocated.
    The heap is a chunk of memory dedicated to holding data which size we didn’t know until runtime.
    Think of an HTTP server. As it receives bytes off the wire, we must allocate more and more memory on
    the heap since we cannot know how much more memory we’ll need.
    Allocating heap memory is generally much less efficient than stack allocating the memory.
    This is because of all the machinery that goes into finding space in the heap.
    The allocation function must find open space in the heap and then it must use some of that space
    to mark both how much space is occupied and the fact that the memory is still in use.
    Unlike the stack’s single instruction to allocate space, the heap requires much more work.

    As stated above Swift allocates classes and closures on the heap along with any other
    data that may grow as the program progresses like non-fixed-size arrays and strings.

    In general Swift use much more stack allocation than other languages like MRI Ruby (which uses none)
    and Java (which only stack allocates primitive types).
    It seems, however, that since Swift includes heap allocated classes, and relies more on heap allocation.
    Most experienced Swift programmers are aware of the performance and memory characteristics of stack vs. heap allocated memory.

 */

/* Memory DeAllocation

 Once we’re finished using some memory, we need to deallocate it.

 Static Memory:
     We can skip over statically allocated memory. Just as the memory gets allocated by the OS when the process starts,
     the memory will be deallocated by the OS when the process ends.

     Stack Allocated Memory:
     When a function’s scope ends, the stack pointer is moved “down”,
     effectively deallocating any memory that was allocated for that function.
     This moving of the stack pointer is usually done with one CPU instruction and is very efficient.
     Of course, if the variables are only referenced in CPU registers then no clean up is required.
     They’ll just be overwritten at some point.

     Swift behave more or less as described above, so as long as a given piece of data is stack allocated in Swift,
     it will incur some  cost.

Heap Allocated Memory:
    Swift relies on a form of garbage collection known as Automatic Reference Counting (ARC).

    - Manual Memory Management:
    Swift does not determine at compile time when memory is no longer referenced.
    Instead each time a new reference to a piece of memory is made (e.g. by binding the memory to a new variable name),
    the “reference count” for that memory is increased by one. When a specific reference goes out of scope,
    the reference count is decreased by one. When the count reaches zero, the memory is freed.

    This approach works well and can be much more efficient than more traditional garbage collection approaches,
    because it does not require some mechanism to traverse the entire heap searching for memory that is no longer referenced.
    It still requires some runtime book keeping, however, than other garbage collector languages like Rust.
    Rust relies on manual memory management, where when to do heap memory deallocations is not left to some
    runtime system to determine like in garbage collected languages.
    Unlike in C, however, Rust does not require the programmer to type explicit deallocation calls,
    but rather statically determines when data is no longer referenced and inserts calls to the memory deallocation
    function at compile time. This means that in Rust no run time cost is paid to determine when to free heap memory.

    Rust actually also gives the programmer the ability to use reference counting if they deem it necessary.
    Swift always uses atomic updates to the reference count,
    because it does not know whether two threads could be trying to update the count at the same time.
    This atomic updating requires a more expensive CPU instruction than updating the count by first reading it,
    and then adding one to it does. Rust allows the programmer to chose between atomic
    reference count updates and non-atomic reference count updates which aren’t thread safe but are more efficient.
    Because of Rust’s “borrow checking”, trying to use the non-thread safe version across threads will fail to compile.

 */

/* Optimizations

     Swift does a fair amount of optimizations so what was described above represents the worst case.
     For example, Swift will sometimes perform “stack promotion” which moves some allocations which would normally
     be heap allocations to stack allocations.
     Swift can also sometimes determine the entire lifetime of a piece of memory and insert “retain” and “release” calls
     (Swift’s heap memory allocation/deallocation functions) where they are needed at compile time.
 */
