import Quick
import Nimble

class ReportFilterSpec: QuickSpec {
    override func spec() {

        describe("ReportFilter") {
            it("should have default values for standard filter") {
                let sf = ReportFilter.standard
                expect(sf.desc).to(beNil())
                expect(sf.type).to(beNil())
                expect(sf.address).to(beNil())
                expect(sf.reporter).to(beNil())
                expect(sf.date).to(beNil())
                expect(sf.status).to(beNil())
                expect(sf.start).to(equal(0))
                expect(sf.limit).to(equal(20))
            }

            it("should have dictionary representation") {
                let null = NSNull()
                let sf = ReportFilter.standard

                let sfDict = sf.dictionaryRepresentation

                let descFilter = sfDict["description_filter"] as! NSNull
                expect(descFilter).to(equal(null))

                let typeFilter = sfDict["type_filter"] as! NSNull
                expect(typeFilter).to(equal(null))

                let addrFilter = sfDict["address_filter"] as! NSNull
                expect(addrFilter).to(equal(null))

                let reporterFilter = sfDict["reporter_filter"] as! NSNull
                expect(reporterFilter).to(equal(null))

                let statusFilter = sfDict["status_filter"] as! NSNull
                expect(statusFilter).to(equal(null))

                let startFilter = sfDict["start"] as! Int
                expect(startFilter).to(equal(0))

                let limitFilter = sfDict["limit"] as! Int
                expect(limitFilter).to(equal(20))
            }
        }
    }
}
