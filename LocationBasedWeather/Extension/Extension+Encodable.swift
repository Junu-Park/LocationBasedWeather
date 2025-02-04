//
//  Extension+Encodable.swift
//  FilmAlbum
//
//  Created by 박준우 on 1/31/25.
//

import Foundation

extension Encodable {
    var convertToDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self), let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return dictionary
    }
}

