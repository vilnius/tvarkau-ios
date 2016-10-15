//
//  ReportListResponse.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 15/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

import Argo
import Curry
import Runes

struct ReportListResponse {
    let reports: [Report]
}

extension ReportListResponse: Decodable {
    static func decode(_ json: JSON) -> Decoded<ReportListResponse> {
        return curry(ReportListResponse.init)
            <^> json <|| "result"
    }
}

