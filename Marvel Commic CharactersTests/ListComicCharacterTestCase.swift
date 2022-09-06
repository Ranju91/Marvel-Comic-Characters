//
//  ListComicCharacterTestCase.swift
//  Marvel Commic CharactersTests
//
//  Created by Ranjana on 06/09/22.
//

import XCTest
@testable import Marvel_Commic_Characters

class ListComicCharacterTestCase: XCTestCase {
    var characterDetailModel : [CharacterDetailModel]?
    /*   //MARK: - Test Cases
     Three parameters are passing in an api(hash, timestamp, apiKey), so we can create test cases on that basis. here i am adding some of the test cases
     1. All the parameters are empty
     2. Wrong hash key
     3. Wrong api key
     4. Missing of param name timestamp/hashKey/apiKey
     5. With all appropriate params
     */
    
    //MARK: - When all the params are empty and will error
    func testWhenAllParamsAreEmpty() {
        let expectation = self.expectation(description: "AllParamsAreEmpty")
        let params = ["ts": "", "apikey":"", "hash":""]
        APIRequest.init().GETRequestCall(url: kGetComicList, params: params) { response in
            // ASSERT
            XCTAssertEqual(response, nil) // or we can also fetch errorcode from api response and compare that also.
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - With wrong hash key
    func testWhenWrongHashKey() {
        let expectation = self.expectation(description: "WrongHashKey")
        let params = ["ts": "", "apikey":"", "hash":"1234"]
        APIRequest.init().GETRequestCall(url: kGetComicList, params: params) { response in
            // ASSERT
            XCTAssertEqual(response, nil) // or we can also fetch errorcode from api response and compare that also.
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - With all appropriate params
    func testWhenAllParamsAccurate() {
        //ARRANGE
        let expectation = self.expectation(description: "AllParamsAccurate")
        let ts = String(Int(Date().timeIntervalSinceNow))
        let hash = md5Hash("\(ts)\(kMarvelsPrivateKey)\(kMarvelsPublicKey)")
        let params = ["ts": ts, "apikey":kMarvelsPublicKey, "hash":hash]
        //ACT
        APIRequest.init().GETRequestCall(url: kGetComicList, params: params) { response in
            // ASSERT
            let jsonDecoder = JSONDecoder()
            let comicCharactersModel = try? jsonDecoder.decode(ComicModel.self, from: response!)
            XCTAssertNotNil(comicCharactersModel)
            XCTAssertNotNil(comicCharactersModel?.data)
            XCTAssertEqual(comicCharactersModel?.code, 200)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
