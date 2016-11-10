//
//  Report.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 15/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import Foundation

import Argo
import Curry
import Runes

struct Report {

    let docNo: String
    let desc: String
    let status: ReportStatus
    let address: String
    let x: Float
    let y: Float
    let answer: String?
    let thumbnailUrl: String?
    let type: String?

}

extension Report: Decodable {

    static func decode(_ json: JSON) -> Decoded<Report> {
        let r1 = curry(Report.init)
            <^> json <| "docNo"
            <*> json <| "description"
            <*> json <| "status"
            <*> json <| "address"
            <*> json <| "x"
            <*> json <| "y"

        let r2 = r1
            <*> json <|? "answer"
            <*> json <|? "thumbnail"
            <*> json <|? "type"

        return r2
    }
    
}
