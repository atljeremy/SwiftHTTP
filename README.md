# SwiftHTTP
A proof of concept Swift HTTP library using Property Wrappers to build a singe Service object similar to Square's Retrofit

## Examples

```swift
// Create a couple models instances for testing purposes
let user = User(id: "1")
let list = List(id: "2")

// The `Service` object is where all routes/requests are defined
let service = Service()

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
 
 [x] Implement path mapping based on types
 [x] If query exists, append to path in HTTPRequest
 [x] Use headers in HTTPRequest
 [_] Use body in HTTPRequest
 [_] Add authentication mechanisms