//
//  ReportService.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 16/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

import ReactiveSwift
import Argo

enum ReportServiceError: Error {
    case serviceError(String)
    case requestError

    var localizedDescription: String {
        switch(self) {
        case let .serviceError(cause):
            return cause
        case .requestError:
            return NSLocalizedString("Could not create request.", comment: "Error when request is nil")
        }
    }
}

class ReportService: NSObject {

    var session: URLSession

    init(withSession session: URLSession = URLSession.standard) {
        self.session = session
    }

    func fetchReports(withFilter reportFilter: ReportFilter) -> SignalProducer<[Report], ReportServiceError> {
        let filterParams = reportFilter.dictionaryRepresentation

        let params: [String: AnyObject] = [
            "method": "get_problems" as AnyObject,
            "params": filterParams as AnyObject,
            "id": 6 as AnyObject
        ]

        guard let request = URLRequest.request(for: "", method: "POST", params: params) else {
            let error = ReportServiceError.requestError
            return SignalProducer(error: error)
        }

        return self.session.data(with: request)
            .mapError(makeReportServiceError)
            .flatMap(.merge, transform: parseReportListResponse)
    }

    private func parseReportListResponse(json: AnyObject) -> SignalProducer<[Report], ReportServiceError> {

        let decodedResponse: Decoded<ReportListResponse> = decode(json)

        switch(decodedResponse) {
        case let .success(object):
            return SignalProducer(value: object.reports)
        case let .failure(error):
            return SignalProducer(error: .serviceError(error.description))
        }
    }

    private func makeReportServiceError(_ sessionError: SessionError) -> ReportServiceError {
        return ReportServiceError.serviceError(sessionError.localizedDescription)
    }
}
