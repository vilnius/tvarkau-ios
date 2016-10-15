import Quick
import Nimble

import Argo
import Curry
import Runes

class ReportSpec: QuickSpec {
    override func spec() {

        var json = [String: AnyObject]()

        beforeEach {
            let bundle = Bundle(for: ReportSpec.self)
            let dataUrl = bundle.url(forResource: "Report", withExtension: "json")
            let data = try? Data(contentsOf: dataUrl!)
            json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
        }


        describe("Report") { 
            it("should be decodable") {
                let decodedReport: Decoded<Report> = decode(json)

                switch(decodedReport) {
                case let .success(object):
                    expect(object.docNo).to(equal("test"))
                    expect(object.desc).to(equal("test"))
                    expect(object.status).to(equal("Atlikta"))
                    expect(object.address).to(equal("Laisves pr. 2"))
                    expect(object.x).to(equal(10.1518))
                    expect(object.y).to(equal(2.01118))
                    expect(object.answer).to(equal("Problema buvo išspresta"))
                case let .failure(error):
                    XCTFail("Unable to decode Report: \(error)")
                }
            }

        }
    }
}
