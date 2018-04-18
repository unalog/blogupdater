//
//  DecodeableRxSpec.swift
//  blogupdaterTests
//
//  Created by una on 2018. 4. 18..
//  Copyright © 2018년 una. All rights reserved.
//

import Quick
import Nimble
import Moya
import SwiftyJSON
import RxSwift
import RxBlocking

@testable import blogupdater

private struct ModelMock {
    let something: String
}

extension ModelMock: blogupdater.Decodable {
    static func fromJSON(_ json: AnyObject) -> ModelMock {
        let json = JSON(json)
        let something = json["something"].stringValue
        return ModelMock(something: something)
    }
}


class DecodeableRxSpec: QuickSpec {
    
    override func spec() {
    
        describe("Decodable") {
            it("should map to one modle"){
                let json = "{\"something\": \"else\"}"
                let sut = try! Observable.just(Response(statusCode: 200, data: json.data(using: String.Encoding.utf8)!))
                    .mapToModel(ModelMock.self)
                    .toBlocking()
                    .first()
                
                expect(sut!.something) == "else"
            
            }
            
            it("should map to multiple models"){
                let json = "[{\"something\": \"else\"}, {\"something\": \"oops\"}]"
                
                let sut = try! Observable.just(Response(statusCode: 200, data: json.data(using: String.Encoding.utf8)!))
                    .mapToModels(ModelMock.self)
                    .toBlocking()
                    .first()
                expect(sut!.count) == 2
                expect(sut!.first!.something) == "else"
            }
            
            it ("should map to multiple models whit provided array root key"){
                
               let json = "{\"items\": [{\"something\": \"else\"}, {\"something\": \"oops\"}]}"
                
                let sut = try! Observable.just(Response(statusCode: 200, data: json.data(using: String.Encoding.utf8)!))
                    .mapToModels(ModelMock.self, arrayRootKey: "items")
                    .toBlocking()
                    .first()
                expect(sut!.count) == 2
                expect(sut!.first!.something) == "else"
                expect(sut!.last!.something) == "oops"
                
            }
        }
       
    }
    
}
