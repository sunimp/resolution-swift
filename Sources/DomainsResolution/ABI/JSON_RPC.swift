//
//  JSON_RPC.swift
//  DomainsResolution
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - JsonRpcPayload

public struct JsonRpcPayload: Codable {
    let jsonrpc, id, method: String
    let params: [ParamElement]

    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case method
        case params
    }

    init(jsonrpc: String, id: String, method: String, params: [ParamElement]) {
        self.jsonrpc = jsonrpc
        self.id = id
        self.method = method
        self.params = params
    }

    init(id: String, data: String, to address: String) {
        self.init(
            jsonrpc: "2.0",
            id: id,
            method: "eth_call",
            params: [
                ParamElement.paramClass(ParamClass(data: data, to: address)),
                ParamElement.string("latest"),
            ]
        )
    }
}

// MARK: - ParamElement

public enum ParamElement: Codable {
    case paramClass(ParamClass)
    case string(String)
    case array([ParamElement])
    case dictionary([String: ParamElement])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let elem = try? container.decode(String.self) {
            self = .string(elem)
            return
        }
        if let elem = try? container.decode(ParamClass.self) {
            self = .paramClass(elem)
            return
        }
        if let elem = try? container.decode([ParamElement].self) {
            self = .array(elem)
            return
        }
        if let elem = try? container.decode([String: ParamElement].self) {
            self = .dictionary(elem)
            return
        }

        throw DecodingError.typeMismatch(
            ParamElement.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Wrong type for ParamElement"
            )
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .paramClass(let elem):
            try container.encode(elem)
        case .string(let elem):
            try container.encode(elem)
        case .array(let array):
            try container.encode(array)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }
}

// MARK: - ParamClass

public struct ParamClass: Codable {
    let data: String
    let to: String
}

// MARK: - JsonRpcResponse

public struct JsonRpcResponse: Decodable {
    let jsonrpc: String
    let id: String
    let result: ParamElement

    enum CodingKeys: String, CodingKey {
        case jsonrpc
        case id
        case result
    }
}
