/*:
 [Table of Contents](Table-of-Contents)
 
 [Previous: Strings](@previous)
 
 #### Strongly Typed Key Paths
 
 [SE-0161](https://github.com/apple/swift-evolution/blob/master/proposals/0161-key-paths.md) introduces smart, strongly typed key paths to the language.
 
 First a recap of Swift 3
 */
import Foundation

class User: NSObject {
    @objc var name: String
    @objc var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

/*:
 In the code above, we have an NSObject subclass with few properties. We can expose individual properties to the Objective-C runtime by adding the `@objc` keyword or by declaring properties as dynamic.
 
 We can define a key path to one of these properties by using the #keyPath syntax. Once we have a key path we can use KVO to observe these properties and KVC to read or write to them.
 */

let keyPath = #keyPath(User.name)

let user = User(name: "Pasan", username: "pasanpr")
let name = user.value(forKey: keyPath)
user.setValue("Pasan Premaratne", forKey: keyPath)

/*:
 There are several downsides to the Swift 3 implementation. Ultimately this key path resolves to a simple string. There's no type safety here and no compiler errors as a result. In addition, this only applies to Objective-C classes, that is, a subclass of `NSObject`. We wouldn't be able to define key paths on Swift value types.
 
 With Swift 4 we can create strongly typed key paths using the following syntax:
*/

let nameKeyPath = \User.name

/*:
 Where in Swift 3 a key path resolved to a String, the type of `nameKeyPath` on the other hand is a generic type - `ReferenceWritableKeyPath` or a KeyPath object which contains information about the class we're referring to - User - and the type of the property, String. Since this key path is to a property on a class, or a reference type, the type of the key path is ReferenceWritable, meaning that we have information about the value semantics of this type.
 
 Using the key path to read and write values is easy and uses sytanx that looks a lot like subscripting. Note that because these key paths are strongly typed, if you assign a type other than String you will get a compiler error.
 */

let nameValue = user[keyPath: nameKeyPath]
user[keyPath: nameKeyPath] = "Pasan"

//: With Swift 4 we can also define key paths on value types

struct Account {
    let name: String
    let users: [User]
    var admin: User?
}

let account = Account(name: "Treehouse Account", users: [user], admin: nil)
let accountNameKeyPath = \Account.name

/*:
 In contrast to the nameKeyPath we defined earlier, `accountNameKeyPath` is of type `KeyPath<Account, String>`. Again this highlights the fact that not only is our key path strongly typed, but contains information about the value semantics of the underlying type.
 
 We can also indicate that a property at the end of a key path is optional. When we use this key path to read a value, the resulting type is also optional.
 */

let adminUsernameKeyPath = \Account.admin?.username
let adminUsername = account[keyPath: adminUsernameKeyPath]

/*:
 We can also use keypaths with arrays using subscript notation. Let's say that we wanted to get the name of the first user associated with this account. This feature has not been implemented yet but would look like this:
 */
// let firstUserKeyPath = \Account.users[0].name

/*:
 Another feature that's in the works is the ability to use type inference when constructing a key path
 */
// let accountName = account[keyPath: \.name]

//: Here we can simply refer to the name property using `.name`. The `Account` type is inferred since we're using the key path on an instance that is of type Account.

//: [Next: Serialization and Archiving](@next)
