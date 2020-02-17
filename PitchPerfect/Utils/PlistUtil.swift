//
//  PlistUtil.swift
//  PitchPerfect
//
//  Created by Razee Hussein-Jamal on 2/17/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import Foundation

enum plistKeyType {
    case WavFile
}

private func getValue(by key: String) -> String? {
    guard let path = Bundle.main.path(forResource: "App", ofType: "plist") else {
        return nil
    }
    guard let value = NSDictionary(contentsOfFile: path)?[key] as? String else {
        return nil
    }
    return value
}

// MARK: PlistUtil

class PlistUtil {
    private init() {}
    
    static func getPlistValue(from type: plistKeyType) -> String? {
        switch type {
        case .WavFile:
            return getValue(by: "WavFile")
        }
    }
}
