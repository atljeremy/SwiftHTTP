/**
 
 # Overview
 
 Proof of Concept demonstratng the use of `@propertyWrapper` to simplify the creation of HTTP requests and provide a "Service" object that defines all endpoints that can be called and the parameters it accepts.
 
 # To-Do
 
 [x] Implement path mapping based on types
 [x] If query exists, append to path in HTTPRequest
 [x] Use headers in HTTPRequest
 [_] Use body in HTTPRequest
 [_] Add authentication mechanisms
 
 */

import Foundation

let user = User(id: "1")
let list = List(id: "2")

let service = Service()

print("service.users")
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

print("")
print("service.user.for(user)")
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

print("")
print("service.userList.with([user])")
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


