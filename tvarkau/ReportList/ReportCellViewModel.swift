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

    private let thumbnailUrl: String?

    var hasThumb: Bool {
        return thumbnailUrl != nil
    }

    init(with report: Report) {
        self.desc = Property(value: report.desc)
        self.status = Property(value: report.status)
        self.address = Property(value: report.address)

        let coords = CLLocationCoordinate2D(latitude: Double(report.x), longitude: Double(report.y))
        self.coordinates = Property(value: coords)

        self.answer = Property(value: report.answer)

        self.thumbnailUrl = report.thumbnailUrl

        let thumbProducer = SignalProducer<UIImage?, NoError> { (observer, disposable) in
            guard let thumbUrlString = report.thumbnailUrl else {
                observer.sendCompleted()
                return
            }

            guard let thumbURL = URL(string: thumbUrlString) else {
                observer.sendCompleted()
                return
            }

            do {
                print("fetching thumbnail")
                let data = try Data(contentsOf: thumbURL)
                let image = UIImage(data: data, scale: UIScreen.main.scale)
                observer.send(value: image)
                observer.sendCompleted()
            } catch {
                observer.sendCompleted()
            }
        }
        self.thumbnail = Property(initial: nil, then: thumbProducer)
    }

}
