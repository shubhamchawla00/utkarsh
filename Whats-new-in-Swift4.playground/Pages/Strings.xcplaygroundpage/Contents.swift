/*:
 [Table of Contents](Table-of-Contents)
 
 [Previous: One Sided Ranges](@previous)
 
 #### Multi-Line String Literals
 
 [SE-0168](https://github.com/apple/swift-evolution/blob/master/proposals/0168-multi-line-string-literals.md) brings multi line string literals to Swift with a very simple syntax. Long strings or multi line strings are strings delimited by triple quotes.\
 
 Multi-line string literals can contain newlines and as well as single quotes without the need to escape them.
*/
let json = """
{
    "glossary": {
        "title": "example glossary",
        "GlossDiv": {
            "title": "S",
            "GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "GlossSee": "markup"
                }
            }
        }
    }
}
"""

/*:
 #### Strings are Collections
 
 [SE-0163](https://github.com/apple/swift-evolution/blob/master/proposals/0163-string-revision-1.md) introduces several changes to the String type. In Swift 4 Strings are Collection types again. We can iterate through a String using a for loop without having to access the underlying characters view.
*/
let programmingLanguage = "Swift"

for char in programmingLanguage {
    print(char)
}
/*:
 #### String Slicing Operations
 
 In Swift 3, slicing a String returned a String. This has been changed and in Swift 4 slicing a String returns a new type - `String.Subsequence` or `Substring`.
 */
let second = programmingLanguage.index(after: programmingLanguage.startIndex)
let substring = programmingLanguage[second...]

/*:
 Since String and Substring are two distinct types, functionality added to one isn't automatically available to the other. In the following example, we've extended String to add a new method. If we call this method on a substring we get a compiler error.
 */
extension Character {
    var isUppercase: Bool {
        return String(self) == String(self).uppercased()
    }
}

extension String {
    func strippedUppercase() -> String {
        return self.filter({ !$0.isUppercase })
    }
}

programmingLanguage.strippedUppercase()
// substring.strippedUppercase()

/*:
 To avoid the hassle of having to add functionality to two types, the String API now lives in a new type - `StringProtocol`. String and Substring both conform to the protocol and by extending StringProtocol common functionality can be added to both types.
 
 The only change we have to make is to account for `self` in our method. In StringProtocol, self can refer to either a String or Substring instance. Here we've used the String initializer on self before performing any operations. If self is a Substring, this creates a copy of the slice as a new String we can use.
 */

extension StringProtocol {
    func strippedUppercase() -> String {
        return String(self).filter({ !$0.isUppercase })
    }
}

/*:
 This also indicates that we can't use a Substring where a String is expected. If you have a substring, you need to use the initializer on String to force a copy and create a new string.
 
 [Next: Key Paths](@next)
*/
