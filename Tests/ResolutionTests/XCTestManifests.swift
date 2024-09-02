//
//  XCTestManifests.swift
//
//  Created by Sun on 2020/9/30.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(ResolutionTests.allTests),
        testCase(EthereumABITests.allTests),
        testCase(TokenUriMetadataTests.allTests),
        testCase(ABICoderTests.allTests),
        testCase(UnsLayerL2Tests.allTests),
    ]
}
#endif
