//
//  Report.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/12/22.
//

enum ReportType: Int, Equatable {
  
  struct Report: Equatable {
    let type: ReportType
    var isSelected: Bool
    
    static let `default`: [Report] = [Report(type: .advertising, isSelected: false),
                                      Report(type: .abuse, isSelected: false),
                                      Report(type: .typo, isSelected: false),
                                      Report(type: .privacy, isSelected: false),
                                      Report(type: .irrelevant, isSelected: false),
                                      Report(type: .defamation, isSelected: false),
                                      Report(type: .etc, isSelected: false)]
  }
  
  case advertising
  case abuse
  case typo
  case privacy
  case irrelevant
  case defamation
  case etc
  
  
  var description: String {
    switch self {
    case .advertising:
      return "광고, 홍보"
    case .abuse:
      return "욕설, 음란어 사용"
    case .typo:
      return "과도한 오타, 반복적 사용"
    case .privacy:
      return "개인정보 노출"
    case .irrelevant:
      return "제품과 무관한 내용"
    case .defamation:
      return "명예 훼손, 저작권 침해"
    case .etc:
      return "기타"
    }
  }
}
