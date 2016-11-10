//
//  ReportViewController.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 30/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift

let ShowReportSegueId = "ShowReportSegue"

class ReportViewController: UIViewController {

    var viewModel: ReportViewModel?

    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var queryLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let vm = viewModel else { return }
        
        self.scrollView.isHidden = false
        titleLabel.reactive.text <~ vm.title
        addressLabel.reactive.text <~ vm.address
        queryLabel.reactive.text <~ vm.query
        answerLabel.reactive.text <~ vm.response
    }

}
