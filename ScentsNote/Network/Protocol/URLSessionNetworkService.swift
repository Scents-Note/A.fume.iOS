//
//  URLSessionNetworkService.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/19.
//

import RxSwift

protocol URLSessionNetworkService {
    func post<T: Codable>(
        _ data: T,
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
    func patch<T: Codable>(
        _ data: T,
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
    func delete(
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
    func get(
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>>
}
