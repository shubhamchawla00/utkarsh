/*:
 [Table of Contents](Table-of-Contents)
 
 [Previous: Serialization and Archiving](@previous)
 
 #### Composing Classes and Protocols
 
 Swift 4 brings a much needed change to how we can represent the identity of our types. This is an easy to understand change. Let's say we have a protocol that defines an interface for delivering events and a series of classes, some of which conform to the protocol.
 */
protocol EventDeliverable {
    var id: Int { get set }
}
 
class View {
    func viewDidLoad() {}
}
 
class Notification: EventDeliverable {
    var id: Int = 0
}
 
class Button: View, EventDeliverable {
    var id: Int = 1
    
    override func viewDidLoad() {
        // override implementation
    }
}
 
class Label: View {
    override func viewDidLoad() {
        //
    }
}

/*:
 
 The objects should be pretty self explanatory. First up we have a class named View that represents a view. Next we have a Notification class. Notifications are events and conforms to EventDeliverable.
 
 We then have two subclasses of the View: A button that can deliver an event and conforms to EventDeliverable and a Label.
 
 What if we wanted to write a method that only accepted Views that conformed to EventDeliverable as valid arguments. In Swift 3, we could compose two protocols together using the ampersand operator but if we wanted to restrict types to a class that conformed to a protocol the only way we could do so was with generics and generic constraints.
 
 In Swift 4 this is much easier. Using the ampersand operator we can now compose classes and protocols. Here's a simple example:
 */
 
func triggerEvent(_ eventDeliverableView: View & EventDeliverable) {}
 
/*:
 Inside the function you now have access to the interface defined by EventDeliverable as well as any public methods, properties or subscripts exposed by the View type. If you try to pass a button instance here, it will work but labels and notifications wont.
 
 As I just mentioned we could achieve this in Swift 3 using generics, but there's added flexibility with the new syntax. For example we can create a collection that only contains types that are subclasses of View and conform to EventDeliverable as well.
 */
 
 let eventViews: [View & EventDeliverable] = []
 
/*:
 When we iterate over these instances using a for loop, again we are guaranteed interfaces of both types. It's a change that allows for a much more expressive type system.
 */

for eventDeliverableView in eventViews {
    eventDeliverableView.viewDidLoad()
    print(eventDeliverableView.id)
}
 
/*:
 The changes described above can be found in more detail in proposal [SE-0156: Class and Subtype existentials](https://github.com/apple/swift-evolution/blob/master/proposals/0156-subclass-existentials.md).

 [Next: Associated Type Constraints](@next)
 */
