//
//  ReportCell.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 16/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {

    var viewModel: ReportCellViewModel? {
        didSet {
            guard let vm = self.viewModel else { return }

            titleLabel?.text = vm.address.value
            descLabel?.text = vm.desc.value
            stateLabel?.text = vm.status.value
            
        }
    }

    static let titleIdentifier = "ReportTitleCell"
    static let imageIdentifier = "ReportImageCell"

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var descLabel: UILabel?
    @IBOutlet var stateLabel: UILabel?
    @IBOutlet var updateTimeLabel: UILabel?
    @IBOutlet var thumbView: UIImageView?

}
