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

    func fetchReportAction() -> Action<String, Report, ReportServiceError> {
        return Action { docNo in
            return self.fetchReport(with: docNo)
        }
    }

    func fetchReport(with docNo: String) -> SignalProducer<Report, ReportServiceError> {
        let params: [String: AnyObject] = [
            "method": "get_problem" as AnyObject,
            "params": [ "id": docNo] as AnyObject,
            "id": 7 as AnyObject
        ]

        guard let request = URLRequest.request(for: "", method: "POST", params: params) else {
            let error = ReportServiceError.requestError
            return SignalProducer(error: error)
        }

        return self.session.data(with: request)
            .mapError(makeReportServiceError)
            .flatMap(.merge, transform: parseReportResponse)
    }

    func fetchReportListAction() -> Action<ReportFilter, [Report], ReportServiceError> {
        return Action { filter in
            return self.fetchReportList(withFilter: filter)
        }
    }

    func fetchReportList(withFilter reportFilter: ReportFilter) -> SignalProducer<[Report], ReportServiceError> {
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

    private func parseReportResponse(json: AnyObject) -> SignalProducer<Report, ReportServiceError> {
        let decodedResponse: Decoded<Report> = decode(json)

        switch(decodedResponse) {
        case let .success(report):
            return SignalProducer(value: report)
        case let .failure(error):
            return SignalProducer(error: .serviceError(error.description))
        }
    }

    private func makeReportServiceError(_ sessionError: SessionError) -> ReportServiceError {
        return ReportServiceError.serviceError(sessionError.localizedDescription)
    }
}
