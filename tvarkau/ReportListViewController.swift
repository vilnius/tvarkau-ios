//
//  ReportListViewController.swift
//  tvarkau
//
//  Created by Eimantas Vaiciunas on 16/10/2016.
//  Copyright © 2016 Code For Vilnius. All rights reserved.
//

import UIKit

class ReportListViewController: UITableViewController {

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

        self.refreshControl?.addTarget(self, action: #selector(refreshReports), for: .valueChanged)

        fetchReports()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)

        let report = reports[indexPath.row]
        cell.textLabel?.text = report.docNo

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // MARK: - Private

    private func fetchReports() {
        reportService.fetchReports(withFilter: self.filter).startWithResult { (result) in
            switch(result) {
            case let .success(reports):
                self.reports = reports
            case let .failure(error):
                print(error)
            }

            self.refreshControl?.endRefreshing()
        }
    }

    @objc
    private func refreshReports() {
        self.filter.start = 0
        self.fetchReports()
    }
    

}
