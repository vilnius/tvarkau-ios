//
//  URLRequestExtensions.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 08/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

extension URLRequest {

    static func request(for path: String,
                               method: String = "GET",
                               params: [String: AnyObject]? = nil) -> URLRequest? {
        let defaults = UserDefaults.standard

        guard let hostname = defaults.string(forKey: "TVARKAU_HOSTNAME"),
            let prefix = defaults.string(forKey: "TVARKAU_PREFIX") else {
                return nil
        }

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = hostname
        urlComponents.path = prefix + path

        if let p = params , method == "GET" {
            let queryItems = p.map({ URLQueryItem(name: $0, value: $1 as? String) })

            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        guard let p = params, ["POST", "PUT", "DELETE"].contains(method) else {
            return request
        }

        if let data = try? JSONSerialization.data(withJSONObject: p, options: []) {
            request.httpBody = data
        }
        
        return request
    }

}
