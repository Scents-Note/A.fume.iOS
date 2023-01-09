//
//  DefaultUserDefaultsPersitenceService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//
import Foundation

final class DefaultUserDefaultsPersitenceService: UserDefaultsPersitenceService {
    
    static let shared: DefaultUserDefaultsPersitenceService = DefaultUserDefaultsPersitenceService()
    
    private init() {}
    
    func set(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get<T>(key: String) -> T? {
        let value = UserDefaults.standard.object(forKey: key)
        return value as? T
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
