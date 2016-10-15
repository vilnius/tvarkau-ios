import Quick
import Nimble

import Argo
import Curry
import Runes

class ReportListResponseSpec: QuickSpec {
    override func spec() {

        var json = [String: AnyObject]()

        beforeEach {
            let bundle = Bundle(for: ReportSpec.self)
            let dataUrl = bundle.url(forResource: "ReportListResponse", withExtension: "json")
            let data = try? Data(contentsOf: dataUrl!)
            json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
        }

        describe("Report list response") {

            it("should be decodable") {
                let decodedResponse: Decoded<ReportListResponse> = decode(json)

                switch(decodedResponse) {
                case let .success(object):
                    expect(object.reports).to(haveCount(2))

                    guard let report = object.reports.first else {
                        XCTFail("There's no report in response")
                        return
                    }

                    expect(report.docNo).to(equal("test"))
                case let .failure(error):
                    XCTFail("Failed to decode response: \(error)")
                }
            }
        }
    }
}

struct ReportListResponse {
    let reports: [Report]
}

extension ReportListResponse: Decodable {
    static func decode(_ json: JSON) -> Decoded<ReportListResponse> {
        return curry(ReportListResponse.init)
            <^> json <|| "result"
    }
}

