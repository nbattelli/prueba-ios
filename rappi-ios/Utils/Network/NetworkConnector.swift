//
//  NetworkConnector.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 28/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

enum Result<Model:Decodable> {
    case success(Model)
    case failure(String)
}

private enum NetworkResponse {
    case success
    case failure(String)
}

private enum ResponseModel<Model:Decodable> {
    case success(Model)
    case failure(String)
}

protocol NetworkConnectorProtocol {
    associatedtype Configuration: NetworkConfiguration
    associatedtype Model: Decodable
    func request(_ route: NetworkConfiguration, completion: @escaping (Result<Model>) -> Void)
    func cancel()
}

let baseURLString = "https://api.themoviedb.org/3"
let apiKey = "c10af0e7fc79b0c60d1c6f3179e109b6"

final class NetworkConnector<Configuration: NetworkConfiguration, Model: Decodable>: NetworkConnectorProtocol {
    
    let baseURL = URL(string: baseURLString)!
    
    private var task: URLSessionTask?
    
    final func request(_ route: NetworkConfiguration,
                       completion: @escaping (Result<Model>)->Void)
    {
        let session = URLSession.shared
        
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let response = response as? HTTPURLResponse {
                    let networkResult = self.handleNetworkResponse(response)
                    do {
                        switch networkResult {
                        case .success:
                            let responseModel = try self.handleResponseModel(data: data)
                            switch responseModel {
                            case .success(let model):
                                completion(.success(model))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    } catch (let error) {
                        completion(.failure(error.localizedDescription))
                    }
                }
            })
        } catch {
            completion(.failure("Network error message"))
        }
        self.task?.resume()
    }
    
    final func cancel()
    {
        self.task?.cancel()
    }
}

//MARK: Configuration
extension NetworkConnector {
    private func buildRequest(from configuration: NetworkConfiguration) throws -> URLRequest
    {
        var request = URLRequest(url: baseURL.appendingPathComponent(configuration.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = configuration.httpMethod.rawValue
        
        self.addQueryParameters(configuration.queryParameters, request: &request)
        self.addHeaders(configuration.additionalHeaders, request: &request)
        return request
    }
    
    private func addQueryParameters(_ queryParameters: QueryParameters?,
                                    request: inout URLRequest)
    {
        guard let queryParameters = queryParameters,
            !queryParameters.isEmpty,
            var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            else { return }
        
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key,value) in queryParameters {
            let encodeValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let queryItem = URLQueryItem(name: key,
                                         value: encodeValue)
            urlComponents.queryItems?.append(queryItem)
        }
        
        //Default query parameters
        urlComponents.queryItems?.append(URLQueryItem(name: "api_key",
                                                      value: apiKey))
        request.url = urlComponents.url
    }
    
    private func addHeaders(_ headers: HTTPHeaders?,
                            request: inout URLRequest)
    {
        guard let headers = headers else { return }
        for (key,value) in headers {
            request.setValue(key, forHTTPHeaderField: value)
        }
        
        //Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

//MARK: Handlers
extension NetworkConnector {
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse
    {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure("Client error message")
        case 501...599: return .failure("Server error message")
        case 600: return .failure("Outdated request message")
        default: return .failure("Network error message")
        }
    }
    
    private func handleResponseModel(data: Data?) throws -> ResponseModel<Model>
    {
        guard let data = data else {return ResponseModel.failure("Parse model error message")}
        let decoder = JSONDecoder()
        let model = try decoder.decode(Model.self, from: data)
        return ResponseModel.success(model)
    }
}
