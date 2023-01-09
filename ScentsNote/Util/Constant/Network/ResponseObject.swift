//
//  ResponseObject.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/10/20.
//


struct ResponseObject<T> {
  let message: String?
  let data: T?
  
  enum CodingKeys: String, CodingKey {
    case message
    case data
  }
}

extension ResponseObject: Decodable where T: Decodable  {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    message = try? container.decode(String.self, forKey: .message)
    data = try? container.decode(T.self, forKey: .data)
  }
}
