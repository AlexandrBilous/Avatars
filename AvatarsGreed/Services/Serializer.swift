//
//  Serializer.swift
//  AvatarsGreed
//
//  Created by Marentilo on 24.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

struct Serializer {
    static func deserialize<T : Decodable>(data : Data, model: T.Type) -> T? {
        let decoder = JSONDecoder()
        let value: T? = try? decoder.decode(model, from: data)
        return value
    }
}
