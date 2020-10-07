//
//  APIManager.swift
//  iOSArchitecture
//
//  Created by Amit on 23/02/18.
//  Copyright © 2018 smartData. All rights reserved.
//
import Foundation
import UIKit

public enum HttpMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
    case PATCH
}

private enum ResponseCode: Int {
    case success = 200
    case notFound = 404
}

struct File {
    let name: String?
    let filename: String?
    let data: Data?
    init(name: String?, filename: String?, data: Data?) {
        self.name = name
        self.filename = filename
        self.data = data
    }
}

enum Result <T> {
    case success(T)
    case error(String)
    case customError(ErrorBase)
}

public struct Service {
     //We are creating a tuple for HTTP Method and Service URL to avoid the parameters confusion in functions
    typealias config = (method:HttpMethod, path:String, isHeader: Bool)
}

protocol ApiServiceProtocol {
    func startService<T: Decodable>(config: Service.config, parameters: [String: Any]?, files: [File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void)
    func buildRequest(with method: HttpMethod, url: URL, parameters: [String: Any]?, files: [File]?) -> URLRequest
    func buildParams(parameters: [String: Any]) -> String
    func handleResponse<T: Decodable>(data: Data, response: URLResponse?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void)
}

public class APIService: NSObject, ApiServiceProtocol {
    /// Start the Service
    /// - Parameter Config:We are defining the HTTP method and the server URL in a tuple
    /// - Parameter parameters: parameters which needs to be send on server while hitting the api
    /// - Parameter files: Multimedia Files which may contain images or videos to be uploaded to server.
    /// - Parameter modelType: Get response in Model after serialization the response from server
    /// - Parameter completion: Call back to update the ViewModel
    func startService<T: Decodable>(config: Service.config, parameters: [String: Any]?, files: [File]?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        if !isInternetReachable() {
            completion(.error(AlertMessage.lostInternet))
            return
        }
        guard let url = URL(string: Config.baseURL + config.path) else { return completion(.error(AlertMessage.invalidURL)) }
        
        print("Request URL", url.absoluteString)
        print("Request Parameters", parameters ?? "")
        var request = self.buildRequest(with: config.method, url: url, parameters: parameters, files: files)
        if config.isHeader {
           // we are checking if header is allowed in the api's, then it would pass in the parameter.
           let headers = self.initializeHeaders()
           request.allHTTPHeaderFields = headers
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.error(error!.localizedDescription)) }
            guard let data = data else { return completion(.error(error?.localizedDescription ?? "Data not found."))
            }
            self.handleResponse(data: data, response: response, modelType: modelType, completion: completion)
        }
        task.resume()
    }
    
    private func initializeHeaders() -> [String : String] {
       let headers = [
        Keys.auth: self.bearerToken
       ]
       return headers
    }
    
    private var bearerToken : String {
//           return "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNDksInVzZXJuYW1lIjoic2F1cmFiaCIsImV4cCI6MTYwMjEzMTczNiwiZW1haWwiOiJzYXVyYWJoZHV0dGFzZG1AZ21haWwuY29tIiwib3JpZ19pYXQiOjE2MDE1MjY5MzZ9.uP3B6rDlN3UsKDD67Qa7AnnqUs2NyjSPss2lqfxu_Z4"
       if let token = UserSession.userToken {
           return "\(Keys.jwt) " + token
       }
       return "Bearer "
    }
}

extension APIService {
    /// Building the request for Services
    /// - Parameter method: to indicate the desired action to be performed on Server.
    /// - Parameter url: Api URL
    /// - Parameter parameters: parameters which needs to send server along with the api
    /// - Parameter files: Multimedia Files which needs to send server along with the api
    func buildRequest(with method: HttpMethod, url: URL, parameters: [String: Any]?, files: [File]?) -> URLRequest {
        var request: URLRequest?
        switch method {
        case .GET:
            if let params = parameters, params.count > 0 {
                let queryUrl = url.appendingPathComponent("?"+buildParams(parameters: params))
                request = URLRequest(url: queryUrl)
            } else {
                request = URLRequest(url: url)
            }
            request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .POST, .PUT, .PATCH:
            request = self.buildRequestForMultiMedia(url, method: method, multimediaFiles: files, parameters: parameters)
        default:
            // write code for delete here
            break
        }
       
        request?.httpMethod = method.rawValue
        return request ?? URLRequest(url: url)
    }
    
    func buildRequestForMultiMedia(_ serviceURL: URL, method: HttpMethod, multimediaFiles: [File]?, parameters: [String: Any]?) -> URLRequest {
        var uploadRequest = URLRequest(url: serviceURL)
        
        if let images = multimediaFiles, images.count > 0 {
            let boundary = "Boundary-\(UUID().uuidString)"
            let boundaryPrefix = "--\(boundary)\r\n"
            let boundarySuffix = "--\(boundary)--\r\n"
            uploadRequest.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
            let data = NSMutableData()
            if let params = parameters, params.count > 0 {
                for (key, value) in params {
                    data.append("--\(boundary)\r\n".nsdata)
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                    data.append("\((value as AnyObject).description ?? "")\r\n".nsdata)
                }
            }
            for file in images {
                if let name = file.name, name.count > 0 {
                    data.append(boundaryPrefix.nsdata)
                    data.append("Content-Disposition: form-data; name=\"\(file.name!)\"; filename=\"\(NSString(string: file.filename!))\"\r\n\r\n".nsdata)
                    if let imgData = file.data {
                        data.append(imgData)
                        data.append("\r\n".nsdata)
                    } else {
                        print("Could not read file data")
                    }
                }
            }
            data.append(boundarySuffix.nsdata)
            uploadRequest.httpBody = data as Data
        } else if let params = parameters, params.count > 0 {
            uploadRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let  jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            uploadRequest.httpBody = jsonData
        }
        return uploadRequest
    }
    
    func buildParams(parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for (key, value) in parameters {
            components += self.queryComponents(key, value)
        }
        return (components.map {"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(string: key), escape(string: "\(value)"))])
        }
        return components
    }
    func escape(string: String) -> String {
        if let encodedString = string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            return encodedString
        }
        return ""
    }
}

extension APIService {
    func handleResponse<T: Decodable>(data: Data, response: URLResponse?, modelType: T.Type, completion: @escaping (Result<T?>) -> Void) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        //Update this if your server update HttpResponse code in case of error
        let jsonResponse = NSString(data: data, encoding: String.Encoding.ascii.rawValue)
        print("Server Resonse", jsonResponse)
        switch statusCode {
        case 200 ... 299:
             do {
              let genericModel = try JSONDecoder().decode(modelType, from: data)
              completion(.success(genericModel))
            } catch let error {
              completion(.error(error.localizedDescription))
            }
        case 400 ... 499:
            if statusCode == 401 {
                completion(.error(""))

                DispatchQueue.main.async {
                    // user token has been expired
                    let configAlert: AlertUI = ("", AlertMessage.sessionExpire)
                    
                    UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.Okk) { (onResponse) in
                        Helper.shared.destroySession()
                    }
                }
            } else {
                do {
                    let genericModel = try JSONDecoder().decode(ErrorBase.self, from: data)
                    completion(.customError(genericModel))
                } catch let error {
                    completion(.error(error.localizedDescription))
                }
            }
        default:
            completion(.error("Error message"))
        }
    }
}

extension String {
    var nsdata: Data {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
}
