//
//  ReportViewModel.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 31/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit
import ReactiveSwift

class ReportViewModel {
    
    var title: Property<String?>
    var query: Property<String?>
    var address: Property<String?>
    var response: Property<String?>

    init(_ report: Report) {
        self.title = Property(value: report.type)
        self.query = Property(value: report.desc)
        self.address = Property(value: report.address)
        self.response = Property(value: report.answer)
        fetchReport()
    }

    private func fetchReport() {
        
    }
}
