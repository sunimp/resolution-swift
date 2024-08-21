//
//  ABI.swift
//  DomainsResolution
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import Foundation

public struct ABI {

}

protocol ABIElementPropertiesProtocol {
    var isStatic: Bool {get}
    var isArray: Bool {get}
    var isTuple: Bool {get}
    var arraySize: ABI.Element.ArraySize {get}
    var subtype: ABI.Element.ParameterType? {get}
    var memoryUsage: UInt64 {get}
    var emptyValue: Any {get}
}

protocol ABIEncoding {
    var abiRepresentation: String {get}
}

protocol ABIValidation {
    var isValid: Bool {get}
}
