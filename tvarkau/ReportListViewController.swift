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

    var loadDisposable: Disposable? = nil

    var reports = [Report]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let reportService = ReportService()

    var currentPage: Int = 0
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
            if self.loadDisposable == nil {
                self.fetchReports()
            }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Private

    private func fetchReports() {
        fetchAction = reportService.fetchAction()
        self.loadDisposable = fetchAction?.apply(self.filter).startWithResult { (result) in
            switch(result) {
            case let .success(reports):
                self.reports.append(contentsOf: reports)
                self.filter.advancePage()
            case let .failure(error):
                print(error)
            }

            self.refreshControl?.endRefreshing()
            self.loadDisposable = nil
        }
    }

    @objc
    private func refreshReports() {
        self.filter.resetPaging()
        self.fetchReports()
    }
    

}

extension ReportListViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }

}
