//
//  Contract.swift
//  DomainsResolution
//
//  Created by Sun on 2024/8/21.
//

import Foundation

class ContractZNS {
    let address: String
    let providerURL: String
    let networking: NetworkingLayer

    init(providerURL: String, address: String, networking: NetworkingLayer) {
        self.address = address
        self.providerURL = providerURL
        self.networking = networking
    }

    func fetchSubState(field: String, keys: [String]) throws -> Any {
        let body = JsonRpcPayload(
            jsonrpc: "2.0",
            id: "1",
            method: "GetSmartContractSubState",
            params: [
                ParamElement.string(address),
                ParamElement.string(field),
                ParamElement.array(keys.map { ParamElement.string($0) }),
            ]
        )
        do {
            let response = try postRequest(body)!

            guard
                case ParamElement.dictionary(let dict) = response,
                let results = reduce(dict: dict)[field] as? [String: Any]
            else {
                print("Invalid response, can't process")
                return response
            }

            return results
            // Zilliqa returns null if the domain is not registered,
            // this causes our decoder to fail and throw APIError.decodingError
        } catch APIError.decodingError {
            throw ResolutionError.unregisteredDomain
        }
    }

    private func postRequest(_ body: JsonRpcPayload) throws -> Any? {
        let postRequest = APIRequest(providerURL, networking: networking)
        var resp: JsonRpcResponse? = nil
        var err: Error? = nil
        let semaphore = DispatchSemaphore(value: 0)
        try postRequest.post(body, completion: { result in
            switch result {
            case .success(let response):
                resp = response[0]
            case .failure(let error):
                err = error
            }
            semaphore.signal()
        })
        semaphore.wait()
        guard err == nil else {
            throw err!
        }
        return resp?.result
    }

    // MARK: - PRIVATE Helper functions

    private func reduce(dict: [String: ParamElement]) -> [String: Any] {
        dict.reduce(into: [String: Any]()) { dict, pair in
            let (key, value) = pair

            switch value {
            case .paramClass(let elem):
                dict[key] = elem
            case .string(let elem):
                dict[key] = elem
            case .array(let array):
                dict[key] = self.map(array: array)
            case .dictionary(let dictionary):
                dict[key] = self.reduce(dict: dictionary)
            }
        }
    }

    private func map(array: [ParamElement]) -> [Any] {
        array.map { value -> Any in
            switch value {
            case .paramClass(let elem):
                return elem
            case .string(let elem):
                return elem
            case .array(let array):
                return self.map(array: array)
            case .dictionary(let dictionary):
                return self.reduce(dict: dictionary)
            }
        }
    }
}
