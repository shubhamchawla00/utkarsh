/*:
 [Table of Contents](Table-of-Contents)
 
 [Previous: Key Paths](@previous)
 
 #### Serialization and Archiving
 
 [SE-0166](https://github.com/apple/swift-evolution/blob/master/proposals/0166-swift-archival-serialization.md) introduces serialization and archival APIs to Swift 4 in a very elegant manner.
 
 Let's work through an example to see it in action. Below we have some sample JSON that we'll be working with.
 */

import Foundation
 
let rawJson = """
{
"name": "The Lion King",
"release_date": "2014-01-12T14:00:00Z",
"actors": [
{
"name": "James Earl Jones"
},
{
"name": "Moira Kelly"
}
]
}
"""
 
 let json = rawJson.data(using: .utf8)!

/*:
 Let's define few types to parse some of this JSON.
 */

struct Actor: Codable {
    let name: String
}

struct Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case releaseDate = "release_date"
        case actors
    }
    
    let name: String
    let releaseDate: String
    let actors: [Actor]
}

//: We can use Swift 4's built in decoders to obtain values from JSON and here we're using the `JSONDecoder` type, which takes the type we want to decode to and the JSON data.

let lionKing = try! JSONDecoder().decode(Movie.self, from: json)
 
 
//: And that's all there is to it. If we inspect the values on the instance you can see they match the json data
 
 lionKing.name
 
/*:
 The key here is a new protocol we conformed to, `Codable`. `Codable` is actually two underlying protocols, `Encodable` and `Decodable`.
 
 `Encodable` defines a type that can encode itself into an external representation by providing an implementation for an encode function.
 
 `Decodable`, the counterpart, defines a type that can decode itself from an external representation which is what we did with our code.
 
 Through protocol extensions we already get default implementations for both `init(from:)` and `encode(to:)`. Adding Codable conformance to our type involved no additional work on our end.
 
 So how does the default implementation work? Structured types like ours, which define a set of properties, encode and decode these properties using a set of keys. A single key corresponds to a single property and for the Codable protocol, these keys need to conform to a third protocol named `CodingKey`.
 
 By default the compiler generates an enum named CodingKeys that conforms to the protocol and provides a mapping of property name to string value. Let's provide our own implementation for this so it's evident. Note that we've defined this in the original type but I've commented it out below for ease of reference.
 */

/*
 enum CodingKeys: String, CodingKey {
     case name
     case releaseDate = "release_date"
     case actors
 }
 */
 
/*:
 
 `CodingKeys` defines members that match up to the properties defined in its parent type. For example, we've defined a member named `name` that matches up with the `name` property we've defined in Movie. Note that CodingKeys must be defined as a nested enum within the type we're providing information for. We've also specified that CodingKeys has a raw value of type String. By default this means the case name is used as a string value, and also used to satisfy the CodingKey protocol.
 
 When we use a decoder it asks the type for a set of keys that map to properties. In our case the JSONDecoder asks the asks the Movie type for a set of keys.  Using the keys we've defined in the CodingKeys enum, the decoder can parse the json, extracting the relevant values. In this instance, the JSONDecoder obtains a single key, the enum value `CodingKeys.name` - it calls the string value property on this key and expects this string value to correspond to a key in the JSON schema, which it does. Using this key, it gets the value, and since these keys map to properties, it can assign the "Lion King" value to the name property.
 
The Movie type has a few more properties and the enum CodingKeys has values to match as well. Notice that the `releaseDate` value has a custom raw value. This is because the JSON defines its keys using snake case whereas the Swift convention is to use lower camel case. Had we not provided the custom raw value here, there would be no valid mapping from property name to JSON key.
 
Built in encoders and decoders, like JSONDecoder have support for dates, urls and other Swift types right out of the box. The `releaseDate` property is of type Date,
 
 Let's assign the instance of the decoder to a constant and assign a date decoding strategy.
 */
 
 
 let decoder = JSONDecoder()
 decoder.dateDecodingStrategy = .iso8601
 
 
//: Here we're saying that the date is in the ISO-8601 format. We can now use this decoder to get a date object right away
 
 
 let lk = try! decoder.decode(Movie.self, from: json)
 
 
/*:
 What about when we have nested types? We defined an Actor type earlier along with a stored property in Movie to hold an array of actors. `Actor` conforms to `Codable` and relies on the automatically generated `CodingKeys`. Without having to make any changes the information from the JSON string is parsed and assigned to the right properties.
 
 Query the property and you'll find the right values in there:
 */
 
 
 lionKing.actors.first!.name
 

/*:
 With nested data the easiest way to decode the information is to ensure any wrapper structure is also represented through individual types. For example, with the code we've written so far, we won't be able to just extract the actors information from within the Movie object without having a valid Movie type. This might be a pain depending on how you're trying to parse the information.
 
 There's a lot more you can do with the new APIs, but this should be enough to give you an idea. For more information check out the [Ultimate Guide to JSON Parsing With Swift 4](http://swiftjson.guide).

 [Next: Composing Classes and Protocols](@next)
 */
