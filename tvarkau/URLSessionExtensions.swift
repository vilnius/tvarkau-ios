//
//  URLSessionExtensions.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 16/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

import ReactiveSwift

public enum SessionError: Error {

    case unknownResponse
    case serverError(Int)

    var localizedDescription: String {
        switch(self) {
        case let .unknownResponse(errorString):
            return "Can't parse server response: \(errorString)"
        case let .serverError(httpCode):
            return "Server returned error response: \(httpCode)"
        }
    }
}

extension URLSession {
    class var standard: URLSession {
        let httpHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Accept-Language": Locale.current.languageCode ?? "en",
            "User-Agent": ",.|.. ^.^ ..|.,"
        ]

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = httpHeaders

        return URLSession(configuration: config)
    }
}

extension URLSession {

    public func data(with request: URLRequest) -> SignalProducer<AnyObject, SessionError> {
        return self.reactive.data(with: request).mapError({ (error) -> SessionError in
            return .serverError(error.code)
        }).flatMap(.merge, transform: parseResponse)
    }

    fileprivate func parseResponse(_ data: Data, response: URLResponse) -> SignalProducer<AnyObject, SessionError> {
        let httpResp = response as! HTTPURLResponse

        guard httpResp.statusCode != 204 else {
            return SignalProducer<AnyObject, SessionError>.empty
        }

        do {
            var json: AnyObject
            if data.count > 0 {
                json = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            } else {
                json = [] as AnyObject
            }
            switch(httpResp.statusCode) {
            case 200..<300:
                return SignalProducer<AnyObject, SessionError>(value: json)
            default:
                let error = SessionError.serverError(httpResp.statusCode)
                return SignalProducer<AnyObject, SessionError>(error: error)
            }
        } catch {
            let error = SessionError.unknownResponse
            return SignalProducer<AnyObject, SessionError>(error: error)
        }
    }
    
}
