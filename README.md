# PhantomTypes
A phantom type is a custom type that has one or more unused type parameters.

Phantom types allow you to enforce type-safety without sacrificing readability. It also reduces the amount of tests we need to write because silly mistakes are forbidden by the compiler.

If you're keen to know more, I recommend you [read my medium article](https://medium.com/@cjnevin/expressible-dynamic-phantom-types-513091b63f04).

# Example

Consider we have a User object like this...

```swift
struct User {
  var email: Email = ""
  var name: Name = ""
  var age: Age = 18
  var isAdmin: IsAdmin = false
}
```

If a developer tries to set a `name` value to the `email` property we will get a **type-mismatch error** from the compiler. 

## How can we enforce type-safety?

```swift
enum Types {
  enum Email {}
  enum Name {}
  enum Age {}
  enum IsAdmin {}
}

typealias Email = Phantom<Types.Email, String>
typealias Name = Phantom<Types.Name, String>
typealias Age = Phantom<Types.Age, Int>
typealias Location = Phantom<Types.IsAdmin, Bool>
```

## Adding even more context

We might even consider making them even more explicit, so a `User`'s `email` can't be assigned to another `Email` field in the code, such as the `Login` `email`...

```swift
protocol EmailHaving {}
extension EmailHaving {
  typealias Email = Phantom<Phantom<Self, Types.Email>, String>
}
extension User: EmailHaving {}
extension Login: EmailHaving {}

User().email = Login().email // type-mismatch error!
```

## Using property wrappers

```swift
struct User {
  @Email()
  var email: String
  @Name()
  var name: String
  @Age(18)
  var age: Int
  @IsAdmin()
  var isAdmin: Bool
}
```
