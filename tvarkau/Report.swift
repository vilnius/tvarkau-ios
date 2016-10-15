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
    let status: String
    let address: String
    let x: Float
    let y: Float
    let answer: String?

}

extension Report: Decodable {

    static func decode(_ json: JSON) -> Decoded<Report> {
        return curry(Report.init)
            <^> json <| "docNo"
            <*> json <| "description"
            <*> json <| "status"
            <*> json <| "address"
            <*> json <| "x"
            <*> json <| "y"
            <*> json <|? "answer"
        
    }
    
}
