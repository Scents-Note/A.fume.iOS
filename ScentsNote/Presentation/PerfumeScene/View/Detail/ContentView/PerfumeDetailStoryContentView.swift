//
//  PerfumeDetailStoryContentView.swift
//  ScentsNote
//
//  Created by 황득연 on 2022/11/18.
//

import UIKit
import SnapKit
import Then

class PerfumeDetailStoryContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
    
    var text: String? = ""
    
    func makeContentView() -> UIView & UIContentView {
      return PerfumeDetailStoryContentView(self)
    }
  }
  
  let contentLabel = UILabel().then {
    $0.font = .notoSans(type: .regular, size: 15)
    $0.textColor = .black42
    $0.numberOfLines = 0
  }
  
  let emptyLabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "정보를 준비 중입니다."
    $0.textColor = .lightGray185
    $0.font = .notoSans(type: .regular, size: 15)
  }
  
  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }
  
  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    
    self.addSubview(self.emptyLabel)
    self.emptyLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.addSubview(self.contentLabel)
    self.contentLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(configuration: UIContentConfiguration) {
    guard let configuration = configuration as? Configuration else { return }
    self.contentLabel.text = configuration.text
    if configuration.text?.isEmpty == true {
      self.emptyLabel.text = "정보를 준비 중입니다."
    }
  }

}

extension UICollectionViewListCell {
  func storyConfiguration() -> PerfumeDetailStoryContentView.Configuration {
    PerfumeDetailStoryContentView.Configuration()
  }
}

