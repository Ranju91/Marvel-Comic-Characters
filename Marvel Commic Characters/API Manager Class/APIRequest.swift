//
//  APIRequest.swift
//  Marvel Commic Characters
//
//  Created by Ranjana on 04/09/22.
//

import Foundation

enum HTTPMethodType: String {
    case POST = "POST"
    case GET = "GET"
}

class APIRequest {
    func GETRequestCall(url:String, params:[String:String], completionHandler:@escaping (Data?) -> ()) {
        if InternetConnectCheckClass.isConnectedToNetwork() {
            guard var components = URLComponents(string: url) else {
                return
            }
            components.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            guard let url = components.url else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethodType.GET.rawValue
            let config = URLSessionConfiguration.ephemeral
            let session = URLSession(configuration: config)
            session.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(nil)
                    return
                }
                guard error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                if httpResponse.statusCode == 200 {
                    completionHandler(data)
                } else {
                    completionHandler(nil)
                }
            }.resume()
        } else {
            DispatchQueue.main.async {
                completionHandler(nil)
            //    showAlertViewController(title: kNetworkError, messsage: kConnectionErrorMsg)
            }
        }
    }
}
