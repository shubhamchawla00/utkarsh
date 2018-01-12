/*:
 [Table of Contents](Table-of-Contents)
 
 [Previous: Associated Type Constraints](@previous)
 
 #### Limiting @objc Inference
 
 [SE-0160](https://github.com/apple/swift-evolution/blob/master/proposals/0160-objc-inference.md) isn't a big change per se but its one that you should be aware of because you will certainly run into it. The `@objc` attribute is used when you want to expose something to the Objective-C runtime. The most common place for this is any Swift method you want to refer to using a selector. For example:
 */
import Foundation

class Foo: NSObject {
    @objc func bar() {}
}

let selector = #selector(Foo.bar)

/*:
In Swift 3, there are a lot of places where this attribute is inferred and either a class, property or method exposed to the Objective-C runtime automatically. One of the main reasons for this change is that there's no consistency to when this happens.

In Swift 4, this inference is scaled back. There are definite benefits to this. When you use `@objc`, the Swift compiler creates a thunk method, an intermediate function so to speak, that maps from Objective-C to Swift and records this method along with some metadata. This isn't cost free. This increases the size of the average binary by 6-8% and much of this code sits unused. Having all this metadata also increases load time. By limiting inference both binary size and load times are reduced.

So what does this look like in practice?

- For the most part, you now have to declare `@objc` specifically when you want to expose Swift code to the Objective-C runtime and the compiler will let you know when you need to.
- NSObject subclasses no longer infer `@objc`. This is probably the change that affects binary size the most since there are plenty of NSObject subclasses now that won't be needing thunks all over the place.

With inference removed from NSObject subclasses, there's a new attribute you can use, `@objcMembers`, that reenables `@objc` inference for the class, its extensions, its subclasses and all of their extensions.
*/

@objcMembers
class Bar {
    func baz() {} // implicitly @objc
}

extension Bar {
    func quz() {} // implicitly @objc because of @objcMembers in class declaration
}

/*:
If this all or nothing approach might isn't what you're looking for, there are ways you can selectively expose functions or properties.

A regular class can designate an extension as @objc to expose all methods in the extension to Objective-C. There are caveats though - if any methods within this extension use Swift only features, like tuples or structs, this method is not expressible in Objective-C and throws an error.
*/
 
class SwiftClass { }

@objc extension SwiftClass {
    func foo() { }            // implicitly @objc
    // func bar() -> (Int, Int)  // error: tuple type (Int, Int) not
    // expressible in @objc. add @nonobjc or move this method to fix the issue
}
//: If you have a class that renables @objc because you used @objcMembers in the declaration, but you want to define certain methods that are Swift only, you can use the @nonobjc attribute to not expose the method to Objective-C.
 
@objcMembers
class AnotherClass : NSObject {
    func wibble() { }    // implicitly @objc
}

@nonobjc extension AnotherClass {
    func wobble() { }    // not @objc, despite @objcMembers
}
 
/*:
Even with the aforementioned changes, there are places where @objc will still be inferred.

- If you override a method from a superclass that was defined with the `@objc` keyword, the overridden method in the subclass has `@objc` inferred
- If you are implementing a protocol method where the method or the entire protocol has been annotated with `@objc`, it's inferred here as well.
- `@IBAction`, `@IBOutlet` and `@IBInspectable` attributes also indicate that `@objc` is being inferred here because interaction with Interface Builder occurs through the Objective-C runtime.
- `@NSManaged`, which is used in Core Data code, also means `@objc`, because again, Core Data works with the Objective-C runtime.
- Finally `@GKInspectable` infers `@objc` because interaction with GameplayKit also occurs through the Objective-C runtime.

There's one thing to keep in mind here as well. Another attribute you might have run into before is the `dynamic` keyword. By using the dynamic keyword we're informing the Swift compiler that it should using dynamic dispatch to access that member. Since Swift doesn't implement its own dynamic dispatch model, using the dynamic modifier meant using Objective-C's runtime. This is no longer the case in Swift 4. Dynamic no longer means automatically inferring `@objc`.

The reason for this is to allow Swift room to support dynamism on its own without relying on the Objective-C runtime. This means that to use the dynamic modifier you need to explicitly list the `@objc` keyword. This makes it explicitly clear that the dynamic behavior is tied to the Objective-C.
*/
 
class MyClass {
// dynamic func foo() { }       // error: 'dynamic' method must be '@objc'
@objc dynamic func bar() { } // okay
}
 
//: While this seems complicated, most of these changes are automatically handled by the Swift 4 migration tool.
