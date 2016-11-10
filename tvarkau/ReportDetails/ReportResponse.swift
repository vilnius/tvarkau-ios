//
//  ReportResponse.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 31/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

import Argo
import Curry
import Runes

struct ReportResponse {
    var report: Report
}

extension ReportResponse: Decodable {
    static func decode(_ json: JSON) -> Decoded<Report> {
        let decodedResult: Decoded<[Report]> = json <|| "result"

        switch decodedResult {
        case let .success(reports):
            return pure(reports[0])
        case let .failure(error):
            return .failure(error)
        }
    }
}
