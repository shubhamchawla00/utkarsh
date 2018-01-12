/*:
 [Table of Contents](Table-of-Contents)
 
 ## One-Sided Ranges
 
 [SE-0172](https://github.com/apple/swift-evolution/blob/master/proposals/0172-one-sided-ranges.md) introduces the concept of a one sided range that is created using prefix or postfix operators and existing range syntax.
 
 Let's start by looking at how we would obtain a slice of a String using a range in Swift 3.
 */
let workshop = "What's New in Swift 4:One Sided Ranges"

if let indexOfPunctuation = workshop.index(of: ":") {
    let indexAfter = workshop.index(after: indexOfPunctuation)
    
    let series = workshop[workshop.startIndex..<indexOfPunctuation]
    let title = workshop[indexAfter..<workshop.endIndex]
}

if let indexOfPunctuation = workshop.index(of: ":") {
    let indexAfter = workshop.index(after: indexOfPunctuation)
    
/*:
 In Swift 4, you can use a one sided range for these kinds of operations. For the series string, we can remove the reference to the start index, leaving the lower bound unspecified. This is now inferred and we have a one-sided range. The resulting value is exactly the same.
 */
    let series = workshop[..<indexOfPunctuation]
    
/*:
 Similarly we can also remove the reference to the end index. When defining one sided ranges, the half open range operator is a valid prefix operator, as seen in our usage to get the series substring, but it is not a valid postfix unary operator. For that we use the closed range operator.
 */
    let title = workshop[indexAfter...]
}

/*:
 #### Infinite Sequences
 
 One sided ranges can be used to create infinite sequences.
 */
let infiniteSequence = 1...
let evenValues = (1...).prefix(100).filter { $0 % 2 == 0 }

/*:
 #### Pattern Matching
 
 One sided ranges can also be used for pattern matching. The only downside is that the compiler cannot infer exhaustiveness.
 */
let value = -2

switch value {
case 1...: print("\(value) is a positive number")
case ..<0: print("\(value) is a negative number")
case 0: print("Zero!")
default: fatalError()
}
//: [Next: Strings](@next)
