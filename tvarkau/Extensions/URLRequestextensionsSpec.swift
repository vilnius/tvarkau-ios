import Foundation

import Quick
import Nimble

class URLRequestExtensionsSpec: QuickSpec {
    override func spec() {

        describe("convenience methods") {
            it("should have proper post body for POST method") {
                let params = ["foo": "bar"]
                let req = URLRequest.request(for: "/somePath", method: "POST", params: params as [String : AnyObject]?)

                expect(req.httpMethod).to(equal("POST"))

                guard let paramData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
                    XCTFail("Unparsable params: \(params)")
                    return
                }

                expect(req.httpBody).to(equal(paramData))
            }

            it("should have proper query string for GET method") {
                let params = ["abc": "def", "foo": "bar"]
                let req = URLRequest.request(for: "/getPath", method: "GET", params: params as [String : AnyObject]?)

                expect(req.httpMethod).to(equal("GET"))

                guard let url = req.url else {
                    XCTFail("Unconstructable URL for request: \(req)")
                    return
                }

                expect(url.path).to(equal("/m/m_problems/files/mobile/server.php/getPath"))
                expect(url.query).to(equal("abc=def&foo=bar"))
            }
        }
    }
}
