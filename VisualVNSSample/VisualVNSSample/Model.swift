import Foundation
import Alamofire

class APIClient {
    static let shared = APIClient()
    private init() {}

    private let baseURL = "http://127.0.0.1:8000/api/"
    private let userDefaults = UserDefaults.standard

    // トークンの取得・保存
    private var accessToken: String? {
        userDefaults.string(forKey: "accessToken")
    }

    private func saveAccessToken(_ token: String) {
        userDefaults.set(token, forKey: "accessToken")
    }

    // ユーザー認証
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL + "token/"
        let parameters: [String: String] = ["username": username, "password": password]

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    self.saveAccessToken(tokenResponse.access)
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
    }
    
    // ログアウト
    func logout() {
        userDefaults.removeObject(forKey: "accessToken")
    }


    // Salesman一覧取得
    func fetchSalesmen(completion: @escaping ([Salesman]?) -> Void) {
        guard let token = accessToken else {
            completion(nil)
            return
        }

        let url = baseURL + "salesmen/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [Salesman].self) { response in
                switch response.result {
                case .success(let salesmen):
                    completion(salesmen)
                case .failure:
                    completion(nil)
                }
            }
    }

    // Salesman作成
    func createSalesman(name: String, description: String, completion: @escaping (Bool) -> Void) {
        guard let token = accessToken else {
            completion(false)
            return
        }

        let url = baseURL + "salesmen/"
        let parameters: [String: Any] = ["name": name, "description": description]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                completion(response.error == nil)
            }
    }
    
    // Salesman更新
    func updateSalesman(salesmanID: UUID, name: String, description: String, completion: @escaping (Bool) -> Void) {
            guard let token = accessToken else {
                completion(false)
                return
            }

        let url = baseURL + "salesmen/\(salesmanID.uuidString.lowercased())/"
            let parameters: [String: Any] = [
                "name": name,
                "description": description
            ]
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    completion(response.error == nil)
                }
        }

    // Salesman削除
    func deleteSalesman(salesmanID: UUID, completion: @escaping (Bool) -> Void) {
        guard let token = accessToken else {
            completion(false)
            return
        }

        let url = baseURL + "salesmen/\(salesmanID)/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .delete, headers: headers)
            .response { response in
                completion(response.error == nil)
            }
    }
    
    // City一覧取得
    func fetchCities(completion: @escaping ([City]?) -> Void) {
        guard let token = accessToken else {
            completion(nil)
            return
        }

        let url = baseURL + "cities/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [City].self) { response in
                switch response.result {
                case .success(let city):
                    completion(city)
                case .failure:
                    completion(nil)
                }
            }
    }

    // City作成
    func createCity(name: String, address: String, salesman: UUID, description: String, completion: @escaping (Bool) -> Void) {
        guard let token = accessToken else {
            completion(false)
            return
        }

        let url = baseURL + "cities/"
        let parameters: [String: Any] = ["name": name, "address": address, "salesman_id": salesman.uuidString.lowercased(), "description": description]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                completion(response.error == nil)
            }
    }
    
    // City更新
    func updateCity(cityID: UUID, name: String, address: String, salesman: UUID, description: String, completion: @escaping (Bool) -> Void) {
            guard let token = accessToken else {
                completion(false)
                return
            }

        let url = baseURL + "cities/\(cityID.uuidString.lowercased())/"
            let parameters: [String: Any] = [
                "name": name,
                "address": address,
                "salesman_id": salesman.uuidString.lowercased(),
                "description": description
            ]
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    completion(response.error == nil)
                }
        }

        // City削除
        func deleteCity(cityID: UUID, completion: @escaping (Bool) -> Void) {
            guard let token = accessToken else {
                completion(false)
                return
            }

            let url = baseURL + "cities/\(cityID)/"
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(url, method: .delete, headers: headers)
                .response { response in
                    completion(response.error == nil)
                }
        }
    
    // Route一覧取得
    func fetchRoutes(completion: @escaping ([Route]?) -> Void) {
        guard let token = accessToken else {
            completion(nil)
            return
        }

        let url = baseURL + "routes/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [Route].self) { response in
                switch response.result {
                case .success(let route):
                    completion(route)
                case .failure:
                    completion(nil)
                }
            }
    }

    // Route作成
    func createRoute(name: String, depot: UUID, cities: [UUID], salesmen: [UUID],  description: String, completion: @escaping (Bool) -> Void) {
        guard let token = accessToken else {
            completion(false)
            return
        }

        let url = baseURL + "routes/"
        let parameters: [String: Any] = ["name": name, "depot_id": depot.uuidString.lowercased(), "city_ids": cities.map {$0.uuidString}, "salesman_ids": salesmen.map {$0.uuidString},  "description": description]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                completion(response.error == nil)
            }
    }
    
    // Route更新
    func updateRoute(routeID: UUID, name: String, depot: UUID, cities: [UUID], salesmen: [UUID], description: String, completion: @escaping (Bool) -> Void) {
            guard let token = accessToken else {
                completion(false)
                return
            }

        let url = baseURL + "routes/\(routeID.uuidString.lowercased())/"
            let parameters: [String: Any] = [
                "name": name,
                "depot_id": depot.uuidString,
                "city_ids": cities.map { $0.uuidString },
                "salesman_ids": salesmen.map { $0.uuidString },
                "description": description
            ]
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    completion(response.error == nil)
                }
        }

        // Route を削除
        func deleteRoute(routeID: UUID, completion: @escaping (Bool) -> Void) {
            guard let token = accessToken else {
                completion(false)
                return
            }

            let url = baseURL + "routes/\(routeID)/"
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(url, method: .delete, headers: headers)
                .response { response in
                    completion(response.error == nil)
                }
        }
    
    func fetchSolutions(completion: @escaping ([Solution]?) -> Void) {
        guard let token = accessToken else {
            completion(nil)
            return
        }

        let url = baseURL + "solutions/"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]

        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [Solution].self) { response in
                switch response.result {
                case .success(let solution):
                    completion(solution)
                case .failure:
                    completion(nil)
                }
            }
    }
    
    func register(username: String, password: String, email: String, completion: @escaping (Bool, String?) -> Void) {
            let url = baseURL + "register/"
            let parameters = RegisterRequest(username: username, password: password, email: email)

            AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
                .response { response in
                    switch response.result {
                    case .success:
                        if let statusCode = response.response?.statusCode, statusCode == 201 {
                            completion(true, nil)
                        } else {
                            completion(false, "Registration failed. Please check your input.")
                        }
                    case .failure(let error):
                        completion(false, error.localizedDescription)
                    }
                }
        }
}

// APIレスポンス用のモデル
struct TokenResponse: Decodable {
    let access: String
}

struct RegisterRequest: Encodable {
    let username: String
    let password: String
    let email: String
}

struct tmpSalesman: Identifiable, Decodable, Encodable, Hashable {
    var id: UUID
    var name: String?
    var description: String?
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Salesman: Identifiable, Decodable, Encodable, Hashable {
    var id: UUID
    var name: String
    var description: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct City: Identifiable, Decodable, Hashable {
    var id: UUID
    var name: String
    var address: String
    var salesman: Salesman
    var description: String
    var createdAt: String
    var updatedAt: String
    
    
    enum CodingKeys: String, CodingKey {
            case id = "uuid"
            case name, address, salesman, description
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
}


struct Route: Identifiable, Decodable, Hashable {
    var id: UUID
    var name: String
    var depot: City
    var cities: [City]
    var salesmen: [Salesman]
    var description: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
            case id = "uuid"
            case name, depot, cities, salesmen, description
            case createdAt = "created_at"
            case updatedAt = "updated_at"
    }
}

struct Solution: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var description: String
    var ans: [[Int]]
    var path: [[String]]
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name, description, ans, path
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


