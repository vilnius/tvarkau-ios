//
//  ReportStatus.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 10/11/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit

import Argo
import Runes
import Curry

enum ReportStatus: String {
    case registered, done, postponed, transferred
}


extension ReportStatus: Decodable {
    static func decode(_ json: JSON) -> Decoded<ReportStatus> {
        switch(json) {
        case let .string(str):
            switch(str) {
            case "Registruota":
                return pure(ReportStatus.registered)
            case "Atlikta":
                return pure(ReportStatus.done)
            case "Atidėta":
                return pure(ReportStatus.postponed)
            case "Perduota":
                return pure(ReportStatus.transferred)
            default:
                return .customError("Unknown value: \(str)")
            }
        default:
            return .typeMismatch(expected: "string", actual: json)
        }
    }
}

extension ReportStatus {
    var tint: UIColor {
        switch(self) {
        case .registered:
            return UIColor(red:0.06, green:0.46, blue:0.73, alpha:1.0)
        case .done:
            return UIColor(red:0.22, green:0.71, blue:0.29, alpha:1.0)
        case .postponed:
            return UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
        case .transferred:
            return UIColor(red:1.00, green:0.59, blue:0.00, alpha:1.0)
        }
    }
}

extension ReportStatus: CustomStringConvertible {
    var description: String {
        let descString: String
        switch(self) {
        case .registered:
            descString = "Registruota"
        case .done:
            descString = "Atlikta"
        case .postponed:
            descString = "Atidėta"
        case .transferred:
            descString = "Perduota"
        }
        return descString.uppercased()
    }
}
