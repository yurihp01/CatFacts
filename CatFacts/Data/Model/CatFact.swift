//
//  CatFact.swift
//  CatFacts
//
//  Created by Yuri on 10/02/25.
//

import Foundation

struct CatFact: Decodable {
    let status: Status
    let text: String
    let createdAt: Date
    
    var isLastNinetyDays: Bool {
        let calendar = Calendar.current
        guard let ninetyDaysAgo = calendar.date(byAdding: .day, value: -90, to: Date()) else { return false }
        return createdAt >= ninetyDaysAgo
    }
}

extension CatFact {
    static var mockedFacts: [CatFact] {
        if let url = Bundle.main.url(forResource: "facts", withExtension: "json") {
            let data = try? Data(contentsOf: url)
            let decoder = JSONDecoder.iso8601
            let facts = try? decoder.decode([CatFact].self, from: data ?? Data())
            return facts ?? []
        }
        return []
    }
}
