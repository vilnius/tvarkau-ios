//
//  ReportCell.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 16/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ReportCell: UITableViewCell {

    var viewModel: ReportCellViewModel? {
        didSet {
            guard let vm = self.viewModel else { return }

            titleLabel.reactive.text <~ vm.address
            descLabel.reactive.text <~ vm.desc
            stateLabel.reactive.text <~ vm.status
            statusView.backgroundColor = vm.statusTint.value
        }
    }

    static let titleIdentifier = "ReportTitleCell"
    static let imageIdentifier = "ReportImageCell"

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var updateTimeLabel: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var thumbView: UIImageView?

}
