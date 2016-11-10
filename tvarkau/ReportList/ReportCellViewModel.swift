//
//  ReportCellViewModel.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 17/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit
import CoreLocation

import ReactiveSwift
import enum Result.NoError

class ReportCellViewModel {

    let desc: Property<String>
    let status: Property<String>
    let statusTint: Property<UIColor>
    let address: Property<String>
    let coordinates: Property<CLLocationCoordinate2D>
    let answer: Property<String?>
    let thumbnail: Property<UIImage?>

    private let thumbnailUrl: String?

    var hasThumb: Bool {
        return thumbnailUrl != nil
    }

    init(with report: Report) {
        self.desc = Property(value: report.desc)
        self.status = Property(value: report.status.description)
        self.statusTint = Property(value: report.status.tint)
        self.address = Property(value: report.address)

        let coords = CLLocationCoordinate2D(latitude: Double(report.x), longitude: Double(report.y))
        self.coordinates = Property(value: coords)

        self.answer = Property(value: report.answer)

        self.thumbnailUrl = report.thumbnailUrl

        guard let thumbUrlString = report.thumbnailUrl,
            let thumbUrl = URL(string: thumbUrlString) else {
                self.thumbnail = Property(value: nil)
                return
        }

        let thumbReq = URLRequest(url: thumbUrl)
        let reqProducer: SignalProducer<UIImage?, NoError> = URLSession.shared.reactive.data(with: thumbReq)
            .map { print("got thumb"); return UIImage(data: $0.0, scale: UIScreen.main.scale) }
            .flatMapError { _ in return SignalProducer(value: nil) }

        self.thumbnail = Property(initial: nil, then: reqProducer.observe(on: UIScheduler()))
    }
    
}
