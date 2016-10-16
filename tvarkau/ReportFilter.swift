//
//  ReportFilter.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 15/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

struct ReportFilter {
    let desc: String?
    let type: String?
    let address: String?
    let reporter: String?
    let date: Date?
    let status: String?
    var start: Int?
    let limit: Int = 20

    static var standard: ReportFilter {
        return ReportFilter(desc: nil, type: nil, address: nil, reporter: nil, date: nil, status: nil, start: 0)
    }

    var dictionaryRepresentation: [String: AnyObject] {
        let descFilter = self.desc as AnyObject?
        let typeFilter = self.type as AnyObject?
        let addrFilter = self.address as AnyObject?
        let reporterFilter = self.reporter as AnyObject?
        let statusFilter = self.status as AnyObject?
        let start = self.start as AnyObject?

        var filterDict: [String: AnyObject] = [
            "limit": limit as AnyObject,
            "description_filter": descFilter ?? NSNull(),
            "type_filter": typeFilter ?? NSNull(),
            "address_filter": addrFilter ?? NSNull()
        ]

        filterDict["reporter_filter"] = reporterFilter ?? NSNull()
        filterDict["status_filter"] = statusFilter ?? NSNull()
        filterDict["start"] = start ?? NSNull()

        return filterDict
    }
}
