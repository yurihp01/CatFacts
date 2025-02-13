//
//  FactsApi.swift
//  CatFacts
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import Foundation

// MARK: - Enum
public enum FactsApiURL {
    case catFacts
}

extension FactsApiURL {
    public var url: String {
        switch self {
        case .catFacts:
            return "https://api.npoint.io/18962a8a5d00e62a8d2a"
        }
    }
}
