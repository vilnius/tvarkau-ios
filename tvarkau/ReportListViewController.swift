//
//  ReportListViewController.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 16/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit
import ReactiveSwift

class ReportListViewController: UITableViewController {

    fileprivate var collapseDetailViewController = true
    private var fetchAction: Action<ReportFilter, [Report], ReportServiceError>?

    var reports = [Report]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let reportService = ReportService()
    var filter = ReportFilter.standard

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.splitViewController?.delegate = self

        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.refreshControl?.addTarget(self, action: #selector(refreshReports), for: .valueChanged)

        fetchReports()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count + 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != reports.count else {
            self.fetchReports()
            return tableView.dequeueReusableCell(withIdentifier: "LoadingCell")!
        }

        let report = reports[indexPath.row]
        let viewModel = ReportCellViewModel(with: report)

        var identifier: String = ""

        if viewModel.hasThumb {
            identifier = ReportCell.imageIdentifier
        } else {
            identifier = ReportCell.titleIdentifier
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ReportCell
        cell.viewModel = viewModel

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collapseDetailViewController = false
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowReportSegueId {
            guard let selectedIP = self.tableView.indexPathForSelectedRow else { return }

            let report = self.reports[selectedIP.row]
            let vm = ReportViewModel(report)

            let dstNavC = segue.destination as! UINavigationController
            (dstNavC.topViewController as! ReportViewController).viewModel = vm
        }
    }

    // MARK: - Private

    private func fetchReports() {
        fetchAction = reportService.fetchReportListAction()
        fetchAction?.apply(self.filter).startWithResult { (result) in
            switch(result) {
            case let .success(reports):
                self.reports.append(contentsOf: reports)
                self.filter.advancePage()
            case let .failure(error):
                print(error)
            }

            self.refreshControl?.endRefreshing()
        }
    }

    @objc
    private func refreshReports() {
        self.filter.resetPaging()
        self.reports = []
        self.tableView.reloadData()
        self.fetchReports()
    }
    

}

extension ReportListViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }

}
