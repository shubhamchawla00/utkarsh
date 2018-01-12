/*:
[Table of Contents](Table-of-Contents)

 [Previous: Composing Classes and Protocols](@previous)
 
#### Associated Type Constraints
 
In addition to composing classes and protocols, Swift 4 adds another change that allows for a much more expressive type system. [SE-0142](https://github.com/apple/swift-evolution/blob/master/proposals/0142-associated-types-constraints.md) allows us to constrain associated types in a protocol using a where clause. In Swift 3 where clauses could only be used in generics. By moving this to the protocol level many of the implementations of existing types have been cleaned up.
 
Here's an example of what the interface for Sequence looked like in Swift 3. Note: I'm only focusing on the associated types here and the entire interface for Sequence is not provided. Furthermore, I've renamed Sequence to avoid duplicate type errors.
 */
 
public protocol SequenceStub {

/// A type that provides the sequence's iteration interface and
/// encapsulates its iteration state.
associatedtype Iterator : IteratorProtocol

/// A type that represents a subsequence of some of the sequence's elements.
associatedtype SubSequence
}

//: This is what it looks like in Swift 4.
 
 
public protocol SequenceStub2 {

/// A type representing the sequence's elements.
associatedtype Element where Self.Element == Self.Iterator.Element

/// A type that provides the sequence's iteration interface and
/// encapsulates its iteration state.
associatedtype Iterator : IteratorProtocol

/// A type that represents a subsequence of some of the sequence's elements.
associatedtype SubSequence
}
 
/*:
 Although it's a small change, you'll see that where in Swift 3 we only have the `Iterator`, in Swift 4 the type defines both an `Iterator` and an `Element`. In Swift 3, the associated type `Element` was defined only in the `IteratorProtocol` type. This meant that if we wanted to define `Element` in `Sequence` as well, we'd have to add a constraint to make sure the associated types match every time we extended `Sequence`. This is in addition to any other constraints we'd have to write.
 */
 
// extension SequenceStub where Self.Element == Int, Self.Element == Self.Iterator.Element {}
 
 
//: By adding the ability to define where constraints on the associated type itself we can clean up code like this. Now instead of having to constraint `Iterator.Element` to a particular type when extending Sequence, we can simply say
 
 
extension SequenceStub2 where Element == Int {}
 
/*:
 In addition to cleaning things up nicely, it means that implementation details can be hidden again. We don't have to understand what the IteratorProtocol does and constrain its associated types just to extend Sequence.

 [Next: Limiting @objc Inference](@next)
 */
