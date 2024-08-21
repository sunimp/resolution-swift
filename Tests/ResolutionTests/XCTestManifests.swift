//
//  XCTestManifests.swift
//  ResolutionTests
//
//  Created by Sun on 2024/8/21.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ResolutionTests.allTests),
        testCase(EthereumABITests.allTests),
        testCase(TokenUriMetadataTests.allTests),
        testCase(ABICoderTests.allTests),
        testCase(UnsLayerL2Tests.allTests)
    ]
}
#endif
