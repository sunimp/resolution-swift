//
//  DnsRecordsError.swift
//  DomainsResolution
//
//  Created by Sun on 2024/8/21.
//

import Foundation

public enum DnsRecordsError: Error {
    case dnsRecordCorrupted(recordType: DnsType)
    case inconsistentTtl(recordType: DnsType)
}
