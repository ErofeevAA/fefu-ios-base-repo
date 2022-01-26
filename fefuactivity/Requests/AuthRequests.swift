
import Foundation

class AuthRequests {
    private let urlAuth = "https://fefu.t.feip.co/api/auth"
    
    private let decoder = JSONDecoder()
    
    init() {}
    
    func logout(resolve: @escaping(() -> Void),
                errors: @escaping((SimpleErrorParams) -> Void)) {
        guard let url = URL(string: urlAuth + "/logout") else {
            print("Connection failed")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        } else {
            print("unexpected error with token")
        }
        request.httpBody = nil
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let data = data, let res = response as? HTTPURLResponse {
                        
                if(res.statusCode == 200) {
                    resolve()
                    return
                }
                    
                if (res.statusCode == 401) {
                    do {
                        let errorsData = try self.decoder.decode(SimpleErrorParams.self, from: data)
                        errors(errorsData)
                        return
                    } catch {
                        print(error)
                    }
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    func auth(body: Data, uri: String, token: @escaping((TokenParams) -> Void), errors: @escaping((ErrorParams) -> Void)) {
        guard let url = URL(string: urlAuth + uri) else {
            print("Connection failed")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let data = data, let res = response as? HTTPURLResponse {
                        
                if(199 < res.statusCode && res.statusCode < 300) {
                    do {
                        let tokenData = try self.decoder.decode(TokenParams.self, from: data)
                        token(tokenData)
                    } catch {
                        print(error)
                    }
                    return
                }
                if (399 < res.statusCode && res.statusCode < 500) {
                    do {
                        let errorsData = try self.decoder.decode(ErrorParams.self, from: data)
                        errors(errorsData)
                        return
                    } catch {
                        print(error)
                    }
                    return
                }
            }
        }
        dataTask.resume()
    }
}
