import Foundation

struct GenderParams: Decodable {
    let code: Int
    let name: String
}

struct UserParams: Decodable {
    let id: Int
    let name: String
    let login: String
    let gender: GenderParams
}

struct TokenParams: Decodable {
    let token: String
    let user: UserParams
}

struct ErrorParams: Decodable {
    let errors: [String: [String]]
}

struct SimpleErrorParams: Decodable {
    let message: String
}

struct LoginParams: Encodable {
    let login: String
    let password: String
}

struct RegisterParams: Encodable {
    let login: String
    let password: String
    let name: String
    let gender: Int
}
