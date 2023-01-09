//
//  UserDefaultsPersitenceService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/02.
//

protocol UserDefaultsPersitenceService {
    func set(key: String, value: Any?)
    func get<T>(key: String) -> T?
    func remove(key: String)
}
