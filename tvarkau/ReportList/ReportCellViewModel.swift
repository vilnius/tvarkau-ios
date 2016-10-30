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
    let address: Property<String>
    let coordinates: Property<CLLocationCoordinate2D>
    let answer: Property<String?>
    let thumbnail: Property<UIImage?>

    let hasThumb: Bool

    init(with report: Report) {
        self.desc = Property(value: report.desc)
        self.status = Property(value: report.status)
        self.address = Property(value: report.address)

        let coords = CLLocationCoordinate2D(latitude: Double(report.x), longitude: Double(report.y))
        self.coordinates = Property(value: coords)

        self.answer = Property(value: report.answer)

        guard let thumbURLString = report.thumbnailUrl else {
            self.hasThumb = false
            self.thumbnail = Property(value: nil)
            return
        }

        self.hasThumb = true

        let thumbProducer = SignalProducer<UIImage?, NoError> { (observer, disposable) in
            guard let thumbURL = URL(string: thumbURLString) else {
                observer.sendCompleted()
                return
            }

            do {
                let data = try Data(contentsOf: thumbURL)
                let image = UIImage(data: data, scale: UIScreen.main.scale)
                observer.send(value: image)
            } catch {
                observer.sendCompleted()
            }
        }
        self.thumbnail = Property(initial: nil, then: thumbProducer)
    }

}
