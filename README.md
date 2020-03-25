# SwiftHTTP
A proof of concept Swift HTTP library using Property Wrappers to build a singe Service object similar to Square's Retrofit

## Examples

Start by building a service object that contains all routes/requests
```swift
public struct MyService {
    @GET<[User]>(
        path: .only("/users"),
        version: .path(.v1_1)
    )
    public var users: HTTPRequest

    @GET<User>(
        path: .mapped("/users/{user}", [.expect("user", User.self)]),
        version: .path(.v1_2)
    )
    public var user: HTTPRequest

    @GET<List>(
        path: .mapped("/users/{user}/lists/{list}", [.expect("user", User.self), .expect("list", List.self)]),
        version: .path(.v1_2)
    )
    public var userList: HTTPRequest
    
    public init() {}
}
```

Use `MyService` to make requests.
```swift
// Create a couple models instances for testing purposes
let user = User(id: "1")
let list = List(id: "2")

// The `MyService` object is where all routes/requests are defined
let service = MyService()

// Call the "/users" endpoint and get back a result that contains an array of `User`s
service.users.execute { result in
    switch result {
    case .success(let users):
        print(users)
    case .failure(let error):
        switch error {
        case .badRequest(let message):
            print("bad request: \(message)")
        case .invalidPath(let path):
            print("invalid path: \(path)")
        case .serverError(let message):
            print("server error: \(message)")
        case .unauthorized(let message):
            print("unauthorized: \(message)")
        }
    }
}

// Call the "/users/:id" endpoint for `user` and get back an instance of `User` in the result
service.user.for(user).execute { result in
    switch result {
    case .success(let user):
        print(user)
    case .failure(let error):
        switch error {
        case .badRequest(let message):
            print("bad request: \(message)")
        case .invalidPath(let path):
            print("invalid path: \(path)")
        case .serverError(let message):
            print("server error: \(message)")
        case .unauthorized(let message):
            print("unauthorized: \(message)")
        }
    }
}

// Call the "/users/:user_id/lists/:list_id" endpoint with `user` & `list` and get back an instance of `List` in the result
service.userList.with([user, list]).execute { result in
    switch result {
    case .success(let list):
        print(list)
    case .failure(let error):
        switch error {
        case .badRequest(let message):
            print("bad request: \(message)")
        case .invalidPath(let path):
            print("invalid path: \(path)")
        case .serverError(let message):
            print("server error: \(message)")
        case .unauthorized(let message):
            print("unauthorized: \(message)")
        }
    }
}
```

 ## To-Do
 
 * [x] Implement path mapping based on types
 * [x] If query exists, append to path in HTTPRequest
 * [x] Use headers in HTTPRequest
 * [ ] Use body in HTTPRequest
 * [ ] Add authentication mechanisms
